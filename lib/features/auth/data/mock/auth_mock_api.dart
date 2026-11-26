import 'package:emas/core/network/mock/mock_api.dart';
import 'package:emas/features/auth/data/datasources/auth_endpoints.dart';

/// Backend palsu untuk endpoint auth. Dipakai selama `AppConfig.useMock`.
///
/// Skenario uji (lihat juga `docs/api/auth.md`):
/// - Email `terdaftar@emas.id` atau HP `081200000000` → 422 sudah terdaftar
/// - HP `081299999999` → 500 (simulasi server error)
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
  static const _maxResend = 3;
  static const _otpTtl = 300;
  static const _resendCooldown = 60;

  final Map<String, _PendingRegistration> _pending = {};

  List<MockRoute> get routes => [
        MockRoute.post(AuthEndpoints.register, _register),
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

    final errors = <String, List<String>>{
      if (name.length < 3) 'name': ['Nama minimal 3 karakter'],
      if (!RegExp(r'^08\d{7,13}$').hasMatch(phone)) 'phone': ['Nomor handphone tidak valid'],
      if (!email.contains('@')) 'email': ['Format email tidak valid'],
      if (password.length < 8) 'password': ['Password minimal 8 karakter'],
      if (email == takenEmail) 'email': ['Email sudah terdaftar'],
      if (phone == takenPhone) 'phone': ['Nomor handphone sudah terdaftar'],
    };

    if (errors.isNotEmpty) {
      return MockResponse.error(422, 'Data pendaftaran tidak valid', errors: errors);
    }
    if (phone == serverErrorPhone) {
      return MockResponse.error(500, 'Terjadi kesalahan pada server');
    }

    final id = 'reg_${DateTime.now().millisecondsSinceEpoch}';
    _pending[id] = _PendingRegistration(name: name, phone: phone, email: email);

    return MockResponse.created(_challengeJson(id, phone));
  }

  // ── POST /auth/otp/verify ──────────────────────────────────────────────────

  MockResponse _verifyOtp(MockRequest req) {
    final id = req.body['verification_id'] as String? ?? '';
    final code = req.body['code'] as String? ?? '';
    final pending = _pending[id];

    if (pending == null) {
      return MockResponse.error(404, 'Sesi verifikasi tidak ditemukan, silakan daftar ulang');
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

    _pending.remove(id);
    final now = DateTime.now();
    return MockResponse.ok({
      'user_id': 'usr_${now.millisecondsSinceEpoch}',
      'email': pending.email,
      'display_name': pending.name,
      'photo_url': null,
      'access_token': 'mock-access-${now.millisecondsSinceEpoch}',
      'refresh_token': 'mock-refresh-${now.millisecondsSinceEpoch}',
      'token_expiry': now.add(const Duration(days: 1)).toIso8601String(),
    });
  }

  // ── POST /auth/otp/resend ──────────────────────────────────────────────────

  MockResponse _resendOtp(MockRequest req) {
    final id = req.body['verification_id'] as String? ?? '';
    final pending = _pending[id];

    if (pending == null) {
      return MockResponse.error(404, 'Sesi verifikasi tidak ditemukan, silakan daftar ulang');
    }
    if (pending.resendCount >= _maxResend) {
      return MockResponse.error(429, 'Batas kirim ulang OTP tercapai, coba lagi nanti');
    }

    pending.resendCount++;
    return MockResponse.ok(_challengeJson(id, pending.phone));
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

class _PendingRegistration {
  final String name;
  final String phone;
  final String email;
  int resendCount = 0;

  _PendingRegistration({required this.name, required this.phone, required this.email});
}
