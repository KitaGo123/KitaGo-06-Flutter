// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';

import 'package:kitago/datamodels/customer_dm.dart';
import 'package:kitago/datamodels/agent_dm.dart';
import 'package:kitago/datamodels/paket_dm.dart';
import 'package:kitago/datamodels/rating_dm.dart';
import 'package:kitago/datamodels/penginapan_dm.dart';
import 'package:kitago/datamodels/wisata_dm.dart';
import 'package:kitago/datamodels/booking_dm.dart';
import 'package:http/http.dart' as http;

class APIService {
  static final apiURL = Uri.parse("http://10.0.2.2/KitaGoDB/mysql.php");

  static List<Pakets> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Pakets>((json) => Pakets.fromJson(json)).toList();
  }

  static Future<String> add(String username, password, nama, email, telpNumb, extra, type) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'ADD';
      if (type == "traveller") {
        map['table'] = 'customers';
      } else if (type == "agent") {
        map['table'] = 'penyedia_jasas';
      }
      map['username'] = username;
      map['password'] = password;
      map['nama'] = nama;
      map['email'] = email;
      map['extra'] = extra;
      map['telpNumb'] = telpNumb;
      print(map);

      final response = await http.post(apiURL, body: map);
      print('Create customers Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }
  //Method untuk update customers
  static Future<String> update(
      int id, String username, password, nama, email, telpNumb, extra, type) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = "UPDATED";
      if (type == "traveler") {
        map['table'] = 'customers';
      } else if (type == "agent") {
        map['table'] = 'penyedia_jasas';
      }
      map['id'] = id;
      map['username'] = username;
      map['password'] = password;
      map['nama'] = nama;
      map['email'] = email;
      map['extra'] = extra;
      map['telpNumb'] = telpNumb;

      final response = await http.post(apiURL, body: map);
      print('updateEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Method to Delete an Employee from Database...
  static Future<String> delete(int id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = "DELETED";
      map['table'] = 'customers';
      map['id'] = id;
      
      final response = await http.post(apiURL, body: map);
      print('deleteEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error"; // returning just an "error" string to keep this simple...
    }
  }

  static Future<String> login(String username, password) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = "LOGIN";
      map['username'] = username;
      map['password'] = password;
      
      final response = await http.post(apiURL, body: map);
      print('Login Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return e.toString(); // returning just an "error" string to keep this simple...
    }
  }

  static Future<List<Pakets>> pakets() async {
    try {
      var map = Map<String, dynamic>();
      List<Pakets> list = <Pakets>[];
      map['action'] = 'GET_ALL';
      map['table'] = 'pakets';
      final response = await http.post(apiURL, body: map);
      print('Get pakets Response: ${response.body}');
      list = parseResponse(response.body);
      if (200 == response.statusCode) {
        return list;
      } else {
        return <Pakets>[];
      }
    } catch (e) {
      print(e.toString());
      return <Pakets>[];
    }
  }

  static Future<Pakets> getPaket(int id) async {
    try {
      var map = Map<String, dynamic>();
      Pakets paket;
      map['action'] = 'GET_ONE';
      map['table'] = 'pakets';
      map['id'] = id.toString();
      final response = await http.post(apiURL, body: map);
      print('Get paket Response: ${response.body}');
      paket = Pakets.fromJson(json.decode(response.body)[0]);
      if (200 == response.statusCode) {
        return paket;
      } else {
        return Pakets(id: -1, namaPaket: "", harga: 0, deskripsi: "", idPenginapan: -1, idWisata: -1, idJasa: -1);
      }
    } catch (e) {
      print(e.toString());
      return Pakets(id: -1, namaPaket: "", harga: 0, deskripsi: "", idPenginapan: -1, idWisata: -1, idJasa: -1);
    }
  }

  static Future<String> addPaket(
      int id, String namaPaket, int harga, String deskripsi, int idPenginapan, int idWisata, int idJasa) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = "ADD";
      map['table'] = 'pakets';
      map['namaPaket'] = namaPaket;
      map['harga'] = harga.toString();
      map['deskripsi'] = deskripsi;
      map['idPenginapan'] = idPenginapan.toString();
      map['idWisata'] = idWisata.toString();
      map['idJasa'] = idJasa.toString();

      final response = await http.post(apiURL, body: map);
      print('Add Paket Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<String> updatePaket(
      int id, String namaPaket, int harga, String deskripsi, int idPenginapan, int idWisata, int idJasa) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = "UPDATED";
      map['table'] = 'pakets';
      map['id'] = id.toString();
      map['namaPaket'] = namaPaket;
      map['harga'] = harga.toString();
      map['deskripsi'] = deskripsi;
      map['idPenginapan'] = idPenginapan.toString();
      map['idWisata'] = idWisata.toString();
      map['idJasa'] = idJasa.toString();

      final response = await http.post(apiURL, body: map);
      print('Update Paket Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<String> deletePaket(int id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = "DELETED";
      map['table'] = 'pakets';
      //map['table2'] = 'ratings';
      map['id'] = id.toString();
      //map['id2'] = id2.toString();
      
      final response = await http.post(apiURL, body: map);
      print('deletePaket Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String> rate(int idUser, int idPaket, double rating) async {
    try {
      var map = Map<String, dynamic>();
      var valid = await validateRate(idUser, idPaket);
      print(valid);
      if (valid == -1) {
        map['action'] = "RATE";
      } else {
        map['action'] = "RATED";
        map['id'] = valid.toString();
      }
      map['table'] = 'ratings';
      map['idUser'] = idUser.toString();
      map['idPaket'] = idPaket.toString();
      map['rating'] = rating.toString();
      
      final response = await http.post(apiURL, body: map);
      print('Rate Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return e.toString();
    }
  }

  static Future<int> validateRate(int idUser, int idPaket) async {
    try {
      var map = Map<String, dynamic>();
      List<dynamic> dynam;
      Ratings ratings;
      map['action'] = 'GET_ALL';
      map['table'] = 'ratings';
      final response = await http.post(apiURL, body: map);
      print('Validate rate Response: ${response.body}');
      dynam = json.decode(response.body);
      for (int i=0;i<dynam.length;i++) {
        ratings = Ratings.fromJson(dynam[i]);
        if (idUser == ratings.idUser && idPaket == ratings.idPaket) {
          return ratings.id;
        }
      }
      return -1;
    } catch (e) {
      print(e.toString());
      return -1;
    }
  }

  static Future<double> getRate(int idPaket) async {
    try {
      var map = Map<String, dynamic>();
      List<dynamic> ratings;
      late double rate = 0;
      map['action'] = 'GET_RATE';
      map['table'] = 'ratings';
      map['idPaket'] = idPaket.toString();
      final response = await http.post(apiURL, body: map);
      print('Get rate Response: ${response.body}');
      ratings = json.decode(response.body);
      for (int i=0;i<ratings.length;i++) {
        rate = rate + int.parse(ratings[i]['rating']);
      }
      rate = rate/ratings.length;
      if (200 == response.statusCode) {
        return rate;
      } else {
        return 0;
      }
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

  static Future<PenyediaJasas> getPJ(int id) async {
    try {
      var map = Map<String, dynamic>();
      PenyediaJasas penyediaJasa;
      map['action'] = 'GET_ONE';
      map['table'] = 'penyedia_jasas';
      map['id'] = id.toString();
      final response = await http.post(apiURL, body: map);
      print('Get penyediaJasas Response: ${response.body}');
      penyediaJasa = PenyediaJasas.fromJson(json.decode(response.body)[0]);
      if (200 == response.statusCode) {
        return penyediaJasa;
      } else {
        return PenyediaJasas(id: -1, nama_penyedia_jasa: "", usernameP: "", passwordP: "", telpNumbP: "", alamat: "", emailP: "");
      }
    } catch (e) {
      print(e.toString());
      return PenyediaJasas(id: -1, nama_penyedia_jasa: "", usernameP: "", passwordP: "", telpNumbP: "", alamat: "", emailP: "");
    }
  }

  static Future<Penginapans> getPenginapan(int id) async {
    try {
      var map = Map<String, dynamic>();
      Penginapans penginapan;
      map['action'] = 'GET_ONE';
      map['table'] = 'penginapans';
      map['id'] = id.toString();
      final response = await http.post(apiURL, body: map);
      print('Get penginapans Response: ${response.body}');
      penginapan = Penginapans.fromJson(json.decode(response.body)[0]);
      if (200 == response.statusCode) {
        return penginapan;
      } else {
        return Penginapans(id: -1, namaPenginapan: "", hargaP: 0);
      }
    } catch (e) {
      print(e.toString());
      return Penginapans(id: -1, namaPenginapan: "", hargaP: 0);
    }
  }

  static Future<Wisatas> getWisata(int id) async {
    try {
      var map = Map<String, dynamic>();
      Wisatas wisata;
      map['action'] = 'GET_ONE';
      map['table'] = 'wisatas';
      map['id'] = id.toString();
      final response = await http.post(apiURL, body: map);
      print('Get wisatas Response: ${response.body}');
      wisata = Wisatas.fromJson(json.decode(response.body)[0]);
      if (200 == response.statusCode) {
        return wisata;
      } else {
        return Wisatas(id: -1, namaWisata: "", hargaW: 0);
      }
    } catch (e) {
      print(e.toString());
      return Wisatas(id: -1, namaWisata: "", hargaW: 0);
    }
  }

  static Future<List<dynamic>> getAllPenginapan() async {
    try {
      var map = Map<String, dynamic>();
      List<dynamic> penginapans;
      map['action'] = 'GET_ALL';
      map['table'] = 'penginapans';
      final response = await http.post(apiURL, body: map);
      print('Get all penginapans Response: ${response.body}');
      penginapans = json.decode(response.body);
      if (200 == response.statusCode) {
        return penginapans;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<List<dynamic>> getAllWisata() async {
    try {
      var map = Map<String, dynamic>();
      List<dynamic> wisata;
      map['action'] = 'GET_ALL';
      map['table'] = 'wisatas';
      final response = await http.post(apiURL, body: map);
      print('Get all wisatas Response: ${response.body}');
      wisata = json.decode(response.body);
      if (200 == response.statusCode) {
        return wisata;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<List<dynamic>> getAllBooking() async {
    try {
      var map = Map<String, dynamic>();
      List<dynamic> books;
      map['action'] = 'GET_ALL';
      map['table'] = 'bookings';
      final response = await http.post(apiURL, body: map);
      print('Get all booking Response: ${response.body}');
      books = json.decode(response.body);
      if (200 == response.statusCode) {
        return books;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<List<dynamic>> getBooked(int idUser) async {
    try {
      var map = Map<String, dynamic>();
      List<dynamic> books;
      map['action'] = 'GET_BOOKID';
      map['table'] = 'bookings';
      map['idUser'] = idUser.toString();
      final response = await http.post(apiURL, body: map);
      print('Get Book id Response: ${response.body}');
      books = json.decode(response.body);
      if (200 == response.statusCode) {
        return books;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<String> book(int idCustomer, int idPaket, String tanggalBooking) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = "ADD";
      map['table'] = 'bookings';
      map['idCustomer'] = idCustomer.toString();
      map['idPaket'] = idPaket.toString();
      map['tanggalBooking'] = tanggalBooking;

      final response = await http.post(apiURL, body: map);
      print('Booking Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<List<Pakets>> getMyPackage(int id) async {
    try {
      var map = Map<String, dynamic>();
      List<Pakets> pakets;
      map['action'] = 'GET_PACKAGE';
      map['table'] = 'pakets';
      map['id'] = id.toString();
      final response = await http.post(apiURL, body: map);
      print('Get My Package Response: ${response.body}');
      pakets = parseResponse(response.body);
      if (200 == response.statusCode) {
        return pakets;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<String> refund(int idBooking, int idUser, String dateRefund, String alasan) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = "REFUND";
      map['idBooking'] = idBooking.toString();
      map['idUser'] = idUser.toString();
      map['dateRefund'] = dateRefund;
      map['alasan'] = alasan;

      final response = await http.post(apiURL, body: map);
      print('Refund Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }
}