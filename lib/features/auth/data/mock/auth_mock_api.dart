import 'package:emas/core/network/mock/mock_api.dart';
import 'package:emas/features/auth/data/datasources/auth_endpoints.dart';

/// Backend palsu untuk endpoint auth. Dipakai selama `AppConfig.useMock`.
///
/// Skenario uji (lihat juga `docs/api/auth.md`):
/// - Email `terdaftar@emas.id` atau HP `081200000000` → 422 sudah terdaftar
/// - HP `081299999999` → 500 (simulasi server error)
/// - HP `081288888888` → daftar berhasil, tapi request OTP gagal 503
/// - OTP `123456` → benar; OTP lain → 422 `OTP_INVALID`;
///   OTP `000000` → 422 `OTP_EXPIRED`
/// - Kirim ulang OTP maksimal 3x per sesi → 429
/// - Login: akun demo [demoPhone] / [demoPassword]; [unverifiedPhone] → 403
///   belum verifikasi; password salah 3x → 429 terkunci 1 menit
///
/// State disimpan di memori, hilang saat aplikasi di-restart.
class AuthMockApi {
  static const validOtp = '123456';
  static const expiredOtp = '000000';
  static const takenEmail = 'terdaftar@emas.id';
  static const takenPhone = '081200000000';
  static const serverErrorPhone = '081299999999';
  static const otpErrorPhone = '081288888888';

  /// Akun demo yang sudah aktif — bisa langsung login.
  static const demoPhone = '081234567890';
  static const demoPassword = 'Rahasia123';

  /// Akun demo yang belum verifikasi OTP — login → 403.
  static const unverifiedPhone = '081211111111';

  static const _maxLoginAttempts = 3;
  static const _lockDuration = Duration(minutes: 1);
  static const _maxResend = 3;
  static const _otpTtl = 300;
  static const _resendCooldown = 60;

  /// Akun terdaftar (demo + hasil register), key = nomor HP.
  final Map<String, _MockUser> _users = {
    demoPhone: _MockUser(
      id: 'usr_demo',
      name: 'Pengguna Demo',
      phone: demoPhone,
      email: 'demo@emas.id',
      password: demoPassword,
      createdAt: DateTime(2026),
    )..isVerified = true,
    unverifiedPhone: _MockUser(
      id: 'usr_unverified',
      name: 'Belum Verifikasi',
      phone: unverifiedPhone,
      email: 'belum@emas.id',
      password: demoPassword,
      createdAt: DateTime(2026),
    ),
  };

  /// Percobaan login gagal berturut-turut per nomor HP.
  final Map<String, int> _failedLogins = {};
  final Map<String, DateTime> _lockedUntil = {};

  /// Sesi OTP aktif, key = verification_id.
  final Map<String, _OtpSession> _sessions = {};

  List<MockRoute> get routes => [
        MockRoute.post(AuthEndpoints.login, _login),
        MockRoute.post(AuthEndpoints.register, _register),
        MockRoute.post(AuthEndpoints.requestOtp, _requestOtp),
        MockRoute.post(AuthEndpoints.verifyOtp, _verifyOtp),
        MockRoute.post(AuthEndpoints.resendOtp, _resendOtp),
        MockRoute.post(AuthEndpoints.logout, _logout),
      ];

  // ── POST /auth/login ───────────────────────────────────────────────────────

  MockResponse _login(MockRequest req) {
    final phone = (req.body['phone'] as String? ?? '').trim();
    final password = req.body['password'] as String? ?? '';
    final deviceId = (req.body['device_id'] as String? ?? '').trim();

    final errors = <String, List<String>>{
      if (!RegExp(r'^08\d{7,13}$').hasMatch(phone)) 'phone': ['Nomor handphone tidak valid'],
      if (password.isEmpty) 'password': ['Password wajib diisi'],
      if (deviceId.isEmpty) 'device_id': ['Device ID wajib dikirim'],
    };
    if (errors.isNotEmpty) {
      return MockResponse.error(422, 'Data login tidak valid', errors: errors);
    }
    if (phone == serverErrorPhone) {
      return MockResponse.error(500, 'Terjadi kesalahan pada server');
    }

    final lockedUntil = _lockedUntil[phone];
    if (lockedUntil != null && DateTime.now().isBefore(lockedUntil)) {
      final seconds = lockedUntil.difference(DateTime.now()).inSeconds + 1;
      return MockResponse.error(429, 'Terlalu banyak percobaan. Coba lagi dalam $seconds detik');
    }

    final user = _users[phone];
    if (user == null || user.password != password) {
      final attempts = (_failedLogins[phone] ?? 0) + 1;
      if (attempts >= _maxLoginAttempts) {
        _failedLogins.remove(phone);
        _lockedUntil[phone] = DateTime.now().add(_lockDuration);
        return MockResponse.error(429, 'Terlalu banyak percobaan. Akun dikunci selama 1 menit');
      }
      _failedLogins[phone] = attempts;
      final left = _maxLoginAttempts - attempts;
      return MockResponse.error(401, 'Nomor handphone atau password salah ($left percobaan tersisa)');
    }

    _failedLogins.remove(phone);
    _lockedUntil.remove(phone);
    user.lastDeviceId = deviceId;

    if (!user.isVerified) {
      return MockResponse.error(
        403,
        'Nomor handphone belum diverifikasi. Kami kirim kode OTP ke nomor Anda',
        code: 'ACCOUNT_NOT_VERIFIED',
      );
    }

    return MockResponse.ok(_sessionJson(user));
  }

  // ── POST /auth/register ────────────────────────────────────────────────────

  MockResponse _register(MockRequest req) {
    final body = req.body;
    final name = (body['name'] as String? ?? '').trim();
    final phone = (body['phone'] as String? ?? '').trim();
    final email = (body['email'] as String? ?? '').trim().toLowerCase();
    final password = body['password'] as String? ?? '';
    final confirmation = body['password_confirmation'] as String? ?? '';
    final termsAccepted = body['terms_accepted'] == true;
    final deviceId = (body['device_id'] as String? ?? '').trim();

    final emailTaken = email == takenEmail || _users.values.any((u) => u.email == email);
    final phoneTaken = phone == takenPhone || _users.containsKey(phone);

    final errors = <String, List<String>>{
      if (name.length < 3) 'name': ['Nama minimal 3 karakter'],
      if (!RegExp(r'^08\d{7,13}$').hasMatch(phone))
        'phone': ['Nomor handphone tidak valid']
      else if (phoneTaken)
        'phone': ['Nomor handphone sudah terdaftar'],
      if (!email.contains('@'))
        'email': ['Format email tidak valid']
      else if (emailTaken)
        'email': ['Email sudah terdaftar'],
      if (password.length < 8) 'password': ['Password minimal 8 karakter'],
      if (confirmation != password) 'password_confirmation': ['Konfirmasi password tidak sama'],
      if (!termsAccepted) 'terms_accepted': ['Syarat & Ketentuan wajib disetujui'],
      if (deviceId.isEmpty) 'device_id': ['Device ID wajib dikirim'],
    };

    if (errors.isNotEmpty) {
      return MockResponse.error(422, 'Data pendaftaran tidak valid', errors: errors);
    }
    if (phone == serverErrorPhone) {
      return MockResponse.error(500, 'Terjadi kesalahan pada server');
    }

    final now = DateTime.now();
    final user = _MockUser(
      id: 'usr_${now.millisecondsSinceEpoch}',
      name: name,
      phone: phone,
      email: email,
      password: password,
      createdAt: now,
    )..lastDeviceId = deviceId;
    _users[phone] = user;

    return MockResponse.ok(user.toJson());
  }

  // ── POST /auth/otp/request ─────────────────────────────────────────────────

  MockResponse _requestOtp(MockRequest req) {
    final phone = (req.body['phone'] as String? ?? '').trim();
    final purpose = req.body['purpose'] as String? ?? '';

    if (purpose != 'register') {
      return MockResponse.error(
        422,
        'Purpose tidak didukung',
        errors: {
          'purpose': ['Mock baru mendukung purpose "register"'],
        },
      );
    }

    final user = _users[phone];
    if (user == null) {
      return MockResponse.error(404, 'Nomor handphone belum terdaftar');
    }
    if (user.isVerified) {
      return MockResponse.error(409, 'Nomor handphone sudah terverifikasi, silakan masuk');
    }
    if (phone == otpErrorPhone) {
      return MockResponse.error(503, 'Layanan SMS sedang gangguan, coba kirim ulang');
    }

    final id = 'otp_${DateTime.now().millisecondsSinceEpoch}';
    _sessions[id] = _OtpSession(phone: phone);
    return MockResponse.ok(_challengeJson(id, phone));
  }

  // ── POST /auth/otp/verify ──────────────────────────────────────────────────

  MockResponse _verifyOtp(MockRequest req) {
    final id = req.body['verification_id'] as String? ?? '';
    final code = req.body['code'] as String? ?? '';
    final session = _sessions[id];
    final user = session == null ? null : _users[session.phone];

    if (session == null || user == null) {
      return MockResponse.error(404, 'Sesi verifikasi tidak ditemukan, silakan minta OTP lagi');
    }
    if (code == expiredOtp) {
      return MockResponse.error(
        422,
        'Kode OTP sudah kedaluwarsa, silakan kirim ulang',
        code: 'OTP_EXPIRED',
        errors: {
          'code': ['Kode OTP sudah kedaluwarsa'],
        },
      );
    }
    if (code != validOtp) {
      return MockResponse.error(
        422,
        'Kode OTP salah',
        code: 'OTP_INVALID',
        errors: {
          'code': ['Kode OTP salah'],
        },
      );
    }

    _sessions.remove(id);
    user.isVerified = true;

    return MockResponse.ok(_sessionJson(user));
  }

  /// Respons sesi login — dipakai `/auth/login` dan `/auth/otp/verify`.
  Map<String, dynamic> _sessionJson(_MockUser user) {
    final now = DateTime.now();
    return {
      'user_id': user.id,
      'email': user.email,
      'display_name': user.name,
      'photo_url': null,
      'access_token': 'mock-access-${now.millisecondsSinceEpoch}',
      'refresh_token': 'mock-refresh-${now.millisecondsSinceEpoch}',
      'token_expiry': now.add(const Duration(days: 1)).toIso8601String(),
    };
  }

  // ── POST /auth/otp/resend ──────────────────────────────────────────────────

  MockResponse _resendOtp(MockRequest req) {
    final id = req.body['verification_id'] as String? ?? '';
    final session = _sessions[id];

    if (session == null) {
      return MockResponse.error(404, 'Sesi verifikasi tidak ditemukan, silakan minta OTP lagi');
    }
    if (session.resendCount >= _maxResend) {
      return MockResponse.error(429, 'Batas kirim ulang OTP tercapai, coba lagi nanti');
    }

    session.resendCount++;
    return MockResponse.ok(_challengeJson(id, session.phone));
  }

  // ── POST /auth/logout ──────────────────────────────────────────────────────

  // Selalu sukses: login saat ini masih di-bypass (tanpa token), dan sesi
  // lokal tetap dihapus aplikasi apa pun respons server.
  MockResponse _logout(MockRequest req) => const MockResponse.ok({'message': 'Berhasil keluar'});

  Map<String, dynamic> _challengeJson(String id, String phone) => {
        'verification_id': id,
        'destination': _mask(phone),
        'expires_in': _otpTtl,
        'resend_in': _resendCooldown,
      };

  String _mask(String phone) {
    if (phone.length <= 6) return phone;
    return '${phone.substring(0, 2)}${'*' * (phone.length - 6)}${phone.substring(phone.length - 4)}';
  }
}

class _MockUser {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String password;
  final DateTime createdAt;
  bool isVerified = false;

  /// Device terakhir yang dipakai register/login (hanya disimpan di mock).
  String? lastDeviceId;

  _MockUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'user_id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'status': isVerified ? 'active' : 'pending_verification',
        'created_at': createdAt.toIso8601String(),
      };
}

class _OtpSession {
  final String phone;
  int resendCount = 0;

  _OtpSession({required this.phone});
}
