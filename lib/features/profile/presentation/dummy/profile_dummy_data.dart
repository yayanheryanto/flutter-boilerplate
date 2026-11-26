import 'package:emas/features/profile/domain/entities/profile_settings.dart';

// TODO(api): data dummy sementara — ganti dengan data dari repository/BLoC
// begitu endpoint tersedia. Jangan dipakai dari lapisan domain/data.

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
