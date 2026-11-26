import 'package:emas/core/network/mock/mock_api.dart';
import 'package:emas/features/auth/data/datasources/auth_endpoints.dart';

/// Backend palsu untuk endpoint auth. Dipakai selama `AppConfig.useMock`.
///
/// Skenario uji (lihat juga `docs/api/auth.md`):
/// - Email `terdaftar@emas.id` atau HP `081200000000` → 422 sudah terdaftar
/// - HP `081299999999` → 500 (simulasi server error)
/// - HP `081288888888` → daftar berhasil, tapi request OTP gagal 503
/// - OTP `123456` → benar; OTP lain → 422; OTP `000000` → 410 kedaluwarsa
/// - Kirim ulang OTP maksimal 3x per sesi → 429
///
/// State disimpan di memori, hilang saat aplikasi di-restart.
class AuthMockApi {
  static const validOtp = '123456';
  static const expiredOtp = '000000';
  static const takenEmail = 'terdaftar@emas.id';
  static const takenPhone = '081200000000';
  static const serverErrorPhone = '081299999999';
  static const otpErrorPhone = '081288888888';
  static const _maxResend = 3;
  static const _otpTtl = 300;
  static const _resendCooldown = 60;

  /// Akun hasil register, key = nomor HP.
  final Map<String, _MockUser> _users = {};

  /// Sesi OTP aktif, key = verification_id.
  final Map<String, _OtpSession> _sessions = {};

  List<MockRoute> get routes => [
        MockRoute.post(AuthEndpoints.register, _register),
        MockRoute.post(AuthEndpoints.requestOtp, _requestOtp),
        MockRoute.post(AuthEndpoints.verifyOtp, _verifyOtp),
        MockRoute.post(AuthEndpoints.resendOtp, _resendOtp),
      ];

  // ── POST /auth/register ────────────────────────────────────────────────────

  MockResponse _register(MockRequest req) {
    final body = req.body;
    final name = (body['name'] as String? ?? '').trim();
    final phone = (body['phone'] as String? ?? '').trim();
    final email = (body['email'] as String? ?? '').trim().toLowerCase();
    final password = body['password'] as String? ?? '';
    final confirmation = body['password_confirmation'] as String? ?? '';
    final termsAccepted = body['terms_accepted'] == true;

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
      createdAt: now,
    );
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
      return MockResponse.error(410, 'Kode OTP sudah kedaluwarsa, silakan kirim ulang');
    }
    if (code != validOtp) {
      return MockResponse.error(
        422,
        'Kode OTP salah',
        errors: {
          'code': ['Kode OTP salah'],
        },
      );
    }

    _sessions.remove(id);
    user.isVerified = true;

    final now = DateTime.now();
    return MockResponse.ok({
      'user_id': user.id,
      'email': user.email,
      'display_name': user.name,
      'photo_url': null,
      'access_token': 'mock-access-${now.millisecondsSinceEpoch}',
      'refresh_token': 'mock-refresh-${now.millisecondsSinceEpoch}',
      'token_expiry': now.add(const Duration(days: 1)).toIso8601String(),
    });
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
  final DateTime createdAt;
  bool isVerified = false;

  _MockUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
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
