// ignore_for_file: non_constant_identifier_names

class PenyediaJasas {
  final int id;
  final String usernameP;
  final String passwordP;
  final String nama_penyedia_jasa;
  final String emailP;
  final String telpNumbP;
  final String alamat;

  PenyediaJasas({
    required this.id,
    required this.usernameP,
    required this.passwordP,
    required this.nama_penyedia_jasa,
    required this.emailP,
    required this.telpNumbP,
    required this.alamat,
  });

  factory PenyediaJasas.fromJson(Map<String, dynamic> json) {
    return PenyediaJasas(
      id: int.parse(json['id']),
      usernameP: json['usernameP'] as String,
      passwordP: json['passwordP'] as String,
      nama_penyedia_jasa: json['nama_penyedia_jasa'] as String,
      emailP: json['emailP'] as String,
      telpNumbP: json['telpNumbP'] as String,
      alamat: json['alamat'] as String,
    );
  }

  @override
  String toString(){
    return 'PenyediaJasas(id: $id, usernameP: $usernameP, passwordP: $passwordP, nama_penyedia_jasa: $nama_penyedia_jasa, emailP: $emailP, telpNumbP: $telpNumbP, alamat: $alamat)';
  }
}