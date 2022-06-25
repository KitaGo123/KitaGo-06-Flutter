// ignore_for_file: non_constant_identifier_names

class Penginapans {
  final int id;
  final String namaPenginapan;
  final int hargaP;

  Penginapans({
    required this.id,
    required this.namaPenginapan,
    required this.hargaP,
  });

  factory Penginapans.fromJson(Map<String, dynamic> json) {
    return Penginapans(
      id: int.parse(json['id']),
      namaPenginapan: json['namaPenginapan'] as String,
      hargaP: int.parse(json['hargaP']),
    );
  }

  @override
  String toString(){
    return 'Penginapans(id: $id, namaPenginapan: $namaPenginapan, hargaP: $hargaP)';
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'namaPenginapan' : namaPenginapan,
      'hargaP' : hargaP,
    };
  }
}