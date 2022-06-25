// ignore_for_file: non_constant_identifier_names

class Pakets {
  final int id;
  final String namaPaket;
  final int harga;
  final String deskripsi;
  final int idPenginapan;
  final int idWisata;
  final int idJasa;

  Pakets({
    required this.id,
    required this.namaPaket,
    required this.harga,
    required this.deskripsi,
    required this.idPenginapan,
    required this.idWisata,
    required this.idJasa,
  });

  factory Pakets.fromJson(Map<String, dynamic> json) {
    return Pakets(
      id: int.parse(json['id']),
      namaPaket: json['namaPaket'] as String,
      harga: int.parse(json['harga']),
      deskripsi: json['deskripsi'] as String,
      idPenginapan: int.parse(json['idPenginapan']),
      idWisata: int.parse(json['idWisata']),
      idJasa: int.parse(json['idJasa']),
    );
  }

  @override
  String toString(){
    return 'Pakets(id: $id, namaPaket: $namaPaket, harga: $harga, deskripsi: $deskripsi, idPenginapan: $idPenginapan, idWisata: $idWisata, idJasa: $idJasa)';
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'namaPaket' : namaPaket,
      'harga' : harga,
      'deskripsi' : deskripsi,
      'idPenginapan' : idPenginapan,
      'idWisata' : idWisata,
      'idJasa' : idJasa,
    };
  }
}