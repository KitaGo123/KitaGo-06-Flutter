// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kitago/datamodels/customer_dm.dart';
import 'package:kitago/datamodels/paket_dm.dart';
import 'package:kitago/datamodels/penginapan_dm.dart';
import 'package:kitago/datamodels/wisata_dm.dart';
import 'package:kitago/services/blogservice.dart';
import 'package:kitago/view/booking.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ViewPaket extends StatefulWidget {
  ViewPaket({Key? key, required this.paket}) : super(key: key);

  Pakets paket;

  @override
  ViewPaketState createState() {
    return ViewPaketState();
  }
}

class ViewPaketState extends State<ViewPaket> {
  
  Penginapans penginapan = Penginapans(id: -1, namaPenginapan: "", hargaP: 0);
  Wisatas wisata = Wisatas(id: -1, namaWisata: "", hargaW: 0);
  double rate = 0;
  dynamic user;

  @override
  void initState() {
    super.initState();
    _getRate(widget.paket.id);
    getUser();
    getPenginapanWisata(widget.paket.idPenginapan, widget.paket.idWisata);
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user = json.decode(prefs.getString('user')!);
    });
  }

  getPenginapanWisata(idP, idW) async {
    await APIService.getPenginapan(idP).then((p){
      setState((){
        penginapan = p;
      });
    });
    await APIService.getWisata(idW).then((w){
      setState((){
        wisata = w;
      });
    });
  }

  _getRate(int id) async {
    rate = await APIService.getRate(id);
  }

  _rate(double rating) async {
    return await APIService.rate(int.parse(user['id']), widget.paket.id , rating);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    image: DecorationImage(
                      image: widget.paket.id % 7 == 0
                      ? AssetImage("assets/images/green-canyon.png")
                      : widget.paket.id % 5 == 0
                        ? AssetImage("assets/images/kawah-putih.png")
                        : widget.paket.id % 3 == 0
                          ? AssetImage("assets/images/curug-luhur-citoe.png")
                          : widget.paket.id % 2 == 0
                            ? AssetImage("assets/images/pantai-batu-hiu.jpeg")
                            : AssetImage("assets/images/perkebunan-teh-rancabali.png"),
                      fit: BoxFit.cover
                    )
                  ),
                ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                  top: 75,
                  left: 30,
                  right: 30,
                ),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    Text(
                      '${widget.paket.namaPaket}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Price: ${widget.paket.harga}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RatingBar.builder(
                      itemSize: 20,
                      initialRating: rate,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        _rate(rating);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => bookScreen(paket: widget.paket)));},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: const Text('Book Now!'),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Description : ${widget.paket.deskripsi}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, color: Colors.red),
                    Text(
                      'Destination',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                PlaceCard(name: wisata.namaWisata, price: wisata.hargaW),
                const SizedBox(height: 50),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home),
                    Text(
                      'Lodging',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                PlaceCard(name: penginapan.namaPenginapan, price: penginapan.hargaP),
                const SizedBox(height: 50),
                const Text(
                  'Travel Tips',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    '1. Check the current COVID-19 situation at your destination.\n' +
                        '2. If traveling by air, check if your airline requires any testing, vaccination, or other documents.\n' +
                        '3. Prepare to be flexible during your trip as restrictions and policies may change.\n' +
                        '4. Wearing a mask over your nose and mouth is required\n' +
                        '5. Protect yourself and others by watching the protocol\n' +
                        '6. Wash your hands often with soap and water or use hand sanitizer with at least 60% alcohol.',
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}

class PlaceCard extends StatelessWidget {
  PlaceCard({Key? key, required this.name, required this.price}) : super(key: key);

  String name;
  int price;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.network(
                'https://images.unsplash.com/photo-1637127505760-17ef61e55f74?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHx0b3BpYy1mZWVkfDR8RnpvM3p1T0hONnd8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=60',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 170.0,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Price: Rp $price',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
