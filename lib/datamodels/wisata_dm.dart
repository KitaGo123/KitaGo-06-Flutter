// ignore_for_file: non_constant_identifier_names

class Wisatas {
  final int id;
  final String namaWisata;
  final int hargaW;

  Wisatas({
    required this.id,
    required this.namaWisata,
    required this.hargaW,
  });

  factory Wisatas.fromJson(Map<String, dynamic> json) {
    return Wisatas(
      id: int.parse(json['id']),
      namaWisata: json['namaWisata'] as String,
      hargaW: int.parse(json['hargaW']),
    );
  }

  @override
  String toString(){
    return 'Wisatas(id: $id, namaWisata: $namaWisata, hargaW: $hargaW)';
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'namaWisata' : namaWisata,
      'hargaW' : hargaW,
    };
  }
}