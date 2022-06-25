// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kitago/datamodels/agent_dm.dart';
import 'package:kitago/services/blogservice.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kitago/datamodels/paket_dm.dart';
import 'package:intl/intl.dart';
//import 'package:google_fonts/google_fonts.dart';

class bookScreen extends StatefulWidget {
  bookScreen({Key? key, required this.paket}) : super(key: key);

  Pakets paket;

  @override
  bookScreenState createState() {
    return bookScreenState();
  }
}

class bookScreenState extends State<bookScreen> {
  final _formKey = GlobalKey<FormState>();
  final idTravellerCtrl = TextEditingController();
  final idPaketCtrl = TextEditingController();

  String bookingDateCtrl = DateFormat('yyyy-MM-dd').format(DateTime.now()); //User Traveler
  dynamic user;
  late PenyediaJasas pj;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  String? _validate(value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    }
    return null;
  }

  getId() async {
    if (user != null) {
      idTravellerCtrl.text = user['id'];
      idPaketCtrl.text = widget.paket.id.toString();
    }
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user = json.decode(prefs.getString('user')!);
    });
    getId();
    _getPJ(widget.paket.idJasa);
    _book();
  }

  _getPJ(int id) async {
    pj = await APIService.getPJ(id);
  }

  _book() async {
    await APIService.book(int.parse(idTravellerCtrl.text), int.parse(idPaketCtrl.text), bookingDateCtrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/cover-booking.png'),
                fit: BoxFit.cover,
                opacity: 0.8,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top:0, left: 50, right: 50, bottom: 0),
                    margin: const EdgeInsets.only(left: 40, right: 30),
                    width: 400,
                    height : 470,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.9),
                          offset: const Offset(5, 5),
                          blurRadius: 5,
                          spreadRadius: 2.0,
                        )
                      ]
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 10, left: 20,right: 20,),
                            child: Text(
                              'Booking Package',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                            ),
                          ),
                          Text(
                            'Enjoy your travel with us',
                            style: TextStyle( fontSize: 16, color: Colors.black),
                          ),
                          const SizedBox(height: 35),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ID Traveller',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextFormField(
                                controller: idTravellerCtrl,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: _validate,
                                enabled: false,
                              ),
                            ],
                          ), 
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ID Package',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextFormField(
                                controller: idPaketCtrl,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: _validate,
                                enabled: false,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Booking Date',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black),
                                        hintText: bookingDateCtrl,
                                      ),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: _validate,
                                      enabled: false,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: () => showDialog<String>(
                              context: context, 
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text(
                                  "Booking successfully", 
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                content: Text("Please contact the agent traveller to determine the date and pickup point. Contact: ${pj.telpNumbP}", style: TextStyle(fontSize: 14)),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pushNamed(context, '/traveller'),
                                    child: const Text("OK")
                                  )
                                ],
                              )
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black87,
                              minimumSize: const Size(double.infinity, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                            child: const Text('Payment'),
                          ),
                          const SizedBox(height: 10),
                          
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
            ],
          ),
        ],
      ),
      
    );
  }
}