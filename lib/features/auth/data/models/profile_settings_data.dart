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

const dummyAccountInfo = AccountInfo(
  email: 'mail@gmail.com',
  phoneNumber: '081376372632',
);

const dummyProfileInfo = ProfileInfo(
  registeredAs: 'Personal',
  nik: '0123456789876543',
  fullName: 'Dinar Daniswara',
  gender: 'Perempuan',
  birthPlace: 'Jakarta',
  birthDate: '1 Oktober 1996',
  occupation: 'Karyawan Swasta',
  nationality: 'WNI',
);

const dummyAddressInfo = AddressInfo(
  address: 'Jl. Wijaya I',
  rt: '06',
  rw: '18',
  province: 'DKI Jakarta',
  city: 'Jakarta Selatan',
  district: 'Kebayoran Baru',
  subDistrict: 'Petogogan',
);

const dummyBankInfo = BankInfo(
  bankName: 'Allo Bank',
  accountNumber: '081376273627',
  accountHolderName: 'Dinar Daniswara',
);
