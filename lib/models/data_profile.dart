import 'dart:convert';

ProfileEntry profileEntryFromJson(String str) =>
    ProfileEntry.fromJson(json.decode(str));

String profileEntryToJson(ProfileEntry data) => json.encode(data.toJson());

class ProfileEntry {
  String username;
  String nama;
  String noTelp;
  DateTime tanggalLahir;
  bool buyer;
  bool seller;
  String? profileImage;
  String? jenisKelamin;
  String? email;
  String? alamat;

  ProfileEntry({
    required this.username,
    required this.nama,
    required this.noTelp,
    required this.tanggalLahir,
    required this.buyer,
    required this.seller,
    required this.profileImage,
    required this.jenisKelamin,
    required this.email,
    required this.alamat,
  });

  factory ProfileEntry.fromJson(Map<String, dynamic> json) => ProfileEntry(
        username: json["username"],
        nama: json["nama"],
        noTelp: json["no_telp"],
        tanggalLahir: DateTime.parse(json["tanggal_lahir"]),
        buyer: json["buyer"],
        seller: json["seller"],
        profileImage: json["profile_image"],
        jenisKelamin: json["jenis_kelamin"],
        email: json["email"],
        alamat: json["alamat"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "nama": nama,
        "no_telp": noTelp,
        "tanggal_lahir":
            "${tanggalLahir.year.toString().padLeft(4, '0')}-${tanggalLahir.month.toString().padLeft(2, '0')}-${tanggalLahir.day.toString().padLeft(2, '0')}",
        "buyer": buyer,
        "seller": seller,
        "profile_image": profileImage,
        "jenis_kelamin": jenisKelamin,
        "email": email,
        "alamat": alamat,
      };
}
