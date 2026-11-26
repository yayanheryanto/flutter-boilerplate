class AccountInfo {
  final String email;
  final String phoneNumber;

  const AccountInfo({
    required this.email,
    required this.phoneNumber,
  });
}

class ProfileInfo {
  final String registeredAs;
  final String nik;
  final String fullName;
  final String gender;
  final String birthPlace;
  final String birthDate;
  final String occupation;
  final String nationality;

  const ProfileInfo({
    required this.registeredAs,
    required this.nik,
    required this.fullName,
    required this.gender,
    required this.birthPlace,
    required this.birthDate,
    required this.occupation,
    required this.nationality,
  });
}

class AddressInfo {
  final String address;
  final String rt;
  final String rw;
  final String province;
  final String city;
  final String district;
  final String subDistrict;

  const AddressInfo({
    required this.address,
    required this.rt,
    required this.rw,
    required this.province,
    required this.city,
    required this.district,
    required this.subDistrict,
  });
}

class BankInfo {
  final String bankName;
  final String accountNumber;
  final String accountHolderName;

  const BankInfo({
    required this.bankName,
    required this.accountNumber,
    required this.accountHolderName,
  });
}
