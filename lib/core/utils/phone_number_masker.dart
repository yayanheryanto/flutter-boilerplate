class PhoneNumberMasker {
  static String mask(String phoneNumber) {
    if (phoneNumber.length <= 6) {
      return phoneNumber;
    }

    final prefix = phoneNumber.substring(0, 2);
    final suffix = phoneNumber.substring(phoneNumber.length - 4);
    final masked = '*' * (phoneNumber.length - 6);

    return '$prefix$masked$suffix';
  }
}
