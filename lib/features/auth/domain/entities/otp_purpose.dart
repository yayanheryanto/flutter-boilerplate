/// Konteks halaman OTP — menentukan endpoint yang dipanggil dan tujuan
/// navigasi setelah OTP benar.
enum OtpPurpose {
  /// Verifikasi nomor HP setelah daftar → login otomatis.
  register,

  /// Lupa password → lanjut buat password baru.
  forgotPassword,

  /// Ganti password dari profil.
  changePassword;

  static OtpPurpose fromName(String? name) =>
      OtpPurpose.values.firstWhere((e) => e.name == name, orElse: () => OtpPurpose.register);
}
