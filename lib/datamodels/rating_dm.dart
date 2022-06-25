// ignore_for_file: non_constant_identifier_names

class Ratings {
  final int id;
  final int idUser;
  final int idPaket;
  final int rating;

  Ratings({
    required this.id,
    required this.idUser,
    required this.idPaket,
    required this.rating,
  });

  factory Ratings.fromJson(Map<String, dynamic> json) {
    return Ratings(
      id: int.parse(json['id']),
      idUser: int.parse(json['idUser']),
      idPaket: int.parse(json['idPaket']),
      rating: int.parse(json['rating']),
    );
  }

  @override
  String toString(){
    return 'Ratings(id: $id, idUser: $idUser, idPaket: $idPaket, rating: $rating)';
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'idUser' : idUser,
      'idPaket' : idPaket,
      'rating' : rating
    };
  }
}