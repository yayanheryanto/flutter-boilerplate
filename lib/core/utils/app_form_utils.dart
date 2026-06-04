import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── AppValidators ────────────────────────────────────────────────────────────

/// Composable validators for [TextFormField.validator].
///
/// ```dart
/// validator: AppValidators.compose([
///   AppValidators.required(),
///   AppValidators.email(),
/// ]),
/// ```
class AppValidators {
  AppValidators._();

  /// Composes multiple validators — runs in order, returns first error.
  static String? Function(String?) compose(List<String? Function(String?)> validators) {
    return (value) {
      for (final v in validators) {
        final error = v(value);
        if (error != null) return error;
      }
      return null;
    };
  }

  static String? Function(String?) required({
    String message = 'Kolom ini wajib diisi',
  }) {
    return (v) => (v == null || v.trim().isEmpty) ? message : null;
  }

  static String? Function(String?) email({
    String message = 'Masukkan alamat email yang valid',
  }) {
    return (v) {
      if (v == null || v.isEmpty) return null;
      final regex = RegExp(r'^[\w\.\-+]+@[\w\-]+\.[\w\-]{2,}$');
      return regex.hasMatch(v.trim()) ? null : message;
    };
  }

  static String? Function(String?) minLength(
      int min, {
        String? message,
      }) {
    return (v) {
      if (v == null || v.isEmpty) return null;
      return v.length < min
          ? (message ?? 'Minimal $min karakter')
          : null;
    };
  }

  static String? Function(String?) maxLength(
      int max, {
        String? message,
      }) {
    return (v) {
      if (v == null || v.isEmpty) return null;
      return v.length > max
          ? (message ?? 'Maksimal $max karakter')
          : null;
    };
  }

  static String? Function(String?) exactLength(
      int length, {
        String? message,
      }) {
    return (v) {
      if (v == null || v.isEmpty) return null;
      return v.length != length
          ? (message ?? 'Harus tepat $length karakter')
          : null;
    };
  }

  static String? Function(String?) numeric({
    String message = 'Hanya angka yang diperbolehkan',
  }) {
    return (v) {
      if (v == null || v.isEmpty) return null;
      return double.tryParse(v) == null ? message : null;
    };
  }

  static String? Function(String?) integer({
    String message = 'Masukkan bilangan bulat yang valid',
  }) {
    return (v) {
      if (v == null || v.isEmpty) return null;
      return int.tryParse(v) == null ? message : null;
    };
  }

  static String? Function(String?) phone({
    String message = 'Masukkan nomor telepon yang valid',
  }) {
    return (v) {
      if (v == null || v.isEmpty) return null;
      final digits = v.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
      return (digits.length >= 9 &&
          digits.length <= 15 &&
          RegExp(r'^\d+$').hasMatch(digits))
          ? null
          : message;
    };
  }

  static String? Function(String?) url({
    String message = 'Masukkan URL yang valid',
  }) {
    return (v) {
      if (v == null || v.isEmpty) return null;
      final uri = Uri.tryParse(v);
      return (uri != null && uri.hasScheme && uri.host.isNotEmpty)
          ? null
          : message;
    };
  }

  static String? Function(String?) strongPassword({
    String message =
    'Password harus terdiri dari minimal 8 karakter, huruf besar, huruf kecil, angka, dan karakter khusus',
    int minLength = 8,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireDigit = true,
    bool requireSpecial = true,
  }) {
    return (v) {
      if (v == null || v.isEmpty) return null;
      if (v.length < minLength) {
        return 'Password minimal $minLength karakter';
      }
      if (requireUppercase && !v.contains(RegExp(r'[A-Z]'))) {
        return 'Password harus mengandung minimal 1 huruf besar';
      }
      if (requireLowercase && !v.contains(RegExp(r'[a-z]'))) {
        return 'Password harus mengandung minimal 1 huruf kecil';
      }
      if (requireDigit && !v.contains(RegExp(r'\d'))) {
        return 'Password harus mengandung minimal 1 angka';
      }
      if (requireSpecial &&
          !v.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
        return 'Password harus mengandung minimal 1 karakter khusus';
      }
      return null;
    };
  }

  static String? Function(String?) matchesOther(
      String? Function() getOtherValue, {
        String message = 'Nilai tidak cocok',
      }) {
    return (v) {
      if (v == null || v.isEmpty) return null;
      return v != getOtherValue() ? message : null;
    };
  }

  static String? Function(String?) range(
      num min,
      num max, {
        String? message,
      }) {
    return (v) {
      if (v == null || v.isEmpty) return null;
      final n = num.tryParse(v);
      if (n == null) return 'Masukkan angka yang valid';
      return (n < min || n > max)
          ? (message ?? 'Nilai harus antara $min dan $max')
          : null;
    };
  }

  static String? Function(String?) pattern(
      RegExp regex, {
        required String message,
      }) {
    return (v) {
      if (v == null || v.isEmpty) return null;
      return regex.hasMatch(v) ? null : message;
    };
  }

  static String? Function(String?) noSpecialChars({
    String message = 'Karakter khusus tidak diperbolehkan',
  }) {
    return (v) {
      if (v == null || v.isEmpty) return null;
      return RegExp(r'[^a-zA-Z0-9\s]').hasMatch(v)
          ? message
          : null;
    };
  }
}

// ─── AppInputFormatters ───────────────────────────────────────────────────────

/// Ready-to-use [TextInputFormatter] list builders.
///
/// ```dart
/// inputFormatters: AppInputFormatters.phone(),
/// ```
class AppInputFormatters {
  AppInputFormatters._();

  /// Allows only digits
  static List<TextInputFormatter> digitsOnly() => [
        FilteringTextInputFormatter.digitsOnly,
      ];

  /// Allows digits and common phone chars: +, -, (, ), space
  static List<TextInputFormatter> phone() => [
        FilteringTextInputFormatter.allow(RegExp(r'[\d\+\-\(\)\s]')),
        LengthLimitingTextInputFormatter(16),
      ];

  /// Allows only letters (no digits, no specials)
  static List<TextInputFormatter> lettersOnly() => [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
      ];

  /// Auto-formats credit card number: "1234 5678 9012 3456"
  static List<TextInputFormatter> creditCard() => [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(16),
        _CreditCardFormatter(),
      ];

  /// Auto-formats expiry: "MM/YY"
  static List<TextInputFormatter> expiryDate() => [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
        _ExpiryDateFormatter(),
      ];

  /// Uppercase only
  static List<TextInputFormatter> uppercase() => [
        TextInputFormatter.withFunction(
          (oldValue, newValue) =>
              newValue.copyWith(text: newValue.text.toUpperCase()),
        ),
      ];

  /// Decimal numbers (e.g. price)
  static List<TextInputFormatter> decimal({int decimalPlaces = 2}) => [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,' + decimalPlaces.toString() + r'}$')),
      ];

  /// Limits words count
  static List<TextInputFormatter> maxWords(int max) => [
        TextInputFormatter.withFunction((old, newVal) {
          final words = newVal.text.trim().split(RegExp(r'\s+'));
          if (words.length > max && newVal.text.endsWith(' ')) return old;
          return newVal;
        }),
      ];
}

class _CreditCardFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i != 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll('/', '');
    String formatted = digits;
    if (digits.length >= 2) {
      formatted = '${digits.substring(0, 2)}/${digits.substring(2)}';
    }
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// ─── AppFormState ─────────────────────────────────────────────────────────────

/// Simple mixin to add standard form key + submit helpers to any StatefulWidget.
///
/// ```dart
/// class _MyFormState extends State<MyForm> with AppFormMixin {
///   void _submit() {
///     if (validateForm()) {
///       // proceed
///     }
///   }
/// }
/// ```
mixin AppFormMixin<T extends StatefulWidget> on State<T> {
  final formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  bool get isSubmitting => _isSubmitting;

  bool validateForm() => formKey.currentState?.validate() ?? false;

  void saveForm() => formKey.currentState?.save();

  void resetForm() => formKey.currentState?.reset();

  Future<void> submitForm(Future<void> Function() action) async {
    if (_isSubmitting) return;
    if (!validateForm()) return;

    setState(() => _isSubmitting = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
