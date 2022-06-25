// ignore_for_file: non_constant_identifier_names

class Customers {
  final int id;
  final String usernameC;
  final String passwordC;
  final String nama_lengkap;
  final String emailC;
  final String telpNumbC;
  final DateTime birthDate;

  Customers({
    required this.id,
    required this.usernameC,
    required this.passwordC,
    required this.nama_lengkap,
    required this.emailC,
    required this.telpNumbC,
    required this.birthDate,
  });

  factory Customers.fromJson(Map<String, dynamic> json) {
    return Customers(
      id: json['id'] as int,
      usernameC: json['usernameC'] as String,
      passwordC: json['passwordC'] as String,
      nama_lengkap: json['nama_lengkap'] as String,
      emailC: json['emailC'] as String,
      telpNumbC: json['telpNumbC'] as String,
      birthDate: json['birthDate'] as DateTime,
    );
  }

  @override
  String toString(){
    return 'Customers(id: $id, usernameC: $usernameC, passwordC: $passwordC, nama_lengkap: $nama_lengkap, emailC: $emailC, telpNumbC: $telpNumbC, birthDate: $birthDate)';
  }
}