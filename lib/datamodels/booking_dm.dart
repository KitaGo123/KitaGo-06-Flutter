// ignore_for_file: non_constant_identifier_names

class Bookings {
  final int id;
  final int idCustomer;
  final int idPaket;
  final DateTime tanggalBooking;

  Bookings({
    required this.id,
    required this.idCustomer,
    required this.idPaket,
    required this.tanggalBooking,
  });

  factory Bookings.fromJson(Map<String, dynamic> json) {
    return Bookings(
      id: int.parse(json['id']),
      idCustomer: int.parse(json['idCustomer']),
      idPaket: int.parse(json['idPaket']),
      tanggalBooking: json['tanggal Booking'] as DateTime,
    );
  }

  @override
  String toString(){
    return 'Bookings(id: $id, idCustomer: $idCustomer, idPaket: $idPaket, tanggalBooking: $tanggalBooking)';
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'idCustomer' : idCustomer,
      'idPaket' : idPaket,
      'tanggalBooking' : tanggalBooking,
    };
  }
}