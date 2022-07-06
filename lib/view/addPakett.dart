// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kitago/datamodels/penginapan_dm.dart';
import 'package:kitago/datamodels/wisata_dm.dart';
import 'package:kitago/datamodels/paket_dm.dart';
import 'package:kitago/services/blogservice.dart';

class addPaketScreen extends StatefulWidget {
  addPaketScreen({Key? key, required this.type, required this.id}) : super(key: key);

  static const routeName = "/formPaket";
  String type;
  int id;

  @override
  addPaketScreenState createState() => addPaketScreenState();
}

class addPaketScreenState extends State<addPaketScreen> {
  final _formKey = GlobalKey<FormState>();
  final namaPaketCtrl= TextEditingController();
  String? namaWisataCtrl;
  String? namaPenginapanCtrl;
  final hargaCtrl = TextEditingController();
  final deskripsiCtrl = TextEditingController();
  final namWCtrl = TextEditingController();
  final namPCtrl = TextEditingController();
  List<dynamic> penginapans = [];
  List<String> namaPenginapans = [];
  List<dynamic> wisatas = [];
  List<String> namaWisatas = [];
  late Pakets paket;
  dynamic user;
  int idP = 0;
  int idW = 0;

  String? _validate(value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    getAllPenginapanWisata();
    getUser();
    if (widget.type == "update") {
      _getPaket(widget.id);
    }
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user = json.decode(prefs.getString('user')!);
    });
  }

  _getPaket(int id) async {
    await APIService.getPaket(id).then((p){
      setState((){
        paket = p;
        namaPaketCtrl.text = paket.namaPaket;
        hargaCtrl.text = paket.harga.toString();
        deskripsiCtrl.text = paket.deskripsi;
        for (int i=0;i<penginapans.length;i++){
          if (p.idPenginapan == int.parse(penginapans[i]['id'])) {
            namaPenginapanCtrl = penginapans[i]['namaPenginapan'];
            namPCtrl.text = penginapans[i]['namaPenginapan'];
            idP = int.parse(penginapans[i]['id']);
          }
        }
        for (int i=0;i<wisatas.length;i++) {
          if (p.idWisata == int.parse(wisatas[i]['id'])) {
            namaWisataCtrl = wisatas[i]['namaWisata'];
            namWCtrl.text = wisatas[i]['namaWisata'];
            idW = int.parse(wisatas[i]['id']);
          }
        }
      });
    });
  }

  _paket(namaPaket, harga, deskripsi, namPenginapan, namWisata, idJasa) async {
    int idPenginapan = 0;
    int idWisata = 0;
    for (int i=0;i<penginapans.length;i++) {
      if (penginapans[i]['namaPenginapan'] == namPenginapan) {
        idPenginapan = int.parse(penginapans[i]['id']);
      }
    }
    for (int i=0;i<wisatas.length;i++) {
      if (wisatas[i]['namaWisata'] == namWisata) {
        idWisata = int.parse(wisatas[i]['id']);
      }
    }
    if (widget.type == "update") {
      await APIService.updatePaket(widget.id, namaPaket, int.parse(harga), deskripsi, idPenginapan, idWisata, int.parse(idJasa));
      Navigator.pop(context);
    } else  if (widget.type == "add") {
      await APIService.addPaket(widget.id, namaPaket, int.parse(harga), deskripsi, idPenginapan, idWisata, int.parse(idJasa));
      Navigator.pop(context);
    }
  }

  getAllPenginapanWisata() {
    APIService.getAllPenginapan().then((p){
      setState((){
        penginapans = p;
      });
      for (int i=0;i<penginapans.length;i++) {
        namaPenginapans.add(penginapans[i]['namaPenginapan']);
      }
    });
    APIService.getAllWisata().then((w){
      setState((){
        wisatas = w;
      });
      for (int i=0;i<wisatas.length;i++) {
        namaWisatas.add(wisatas[i]['namaWisata']);
      }
    });
  }

  String? upPenginapan() {
    for (int i=0;i<namaPenginapans.length;i++) {
      if (namPCtrl.text == namaPenginapans[i]) {
        return namaPenginapans[i];
      }
    }
    return null;
  }
  String? upWisata() {
    for (int i=0;i<namaWisatas.length;i++) {
      if (namWCtrl.text == namaWisatas[i]) {
        return namaWisatas[i];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: CustomScrollView(
        primary : false,
        slivers : <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top:50, left: 50, right: 50, bottom: 0),
                  width: 390,
                  height : 670,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/cover-booking.png'),
                      fit: BoxFit.cover,
                      opacity: 0.4,
                      
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.type == "add"
                          ? 'Create Package'
                          : 'Edit Package',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const Text(
                          'Enjoy your travel with us',
                          style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16),
                        ),
                        const SizedBox(height: 40),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nama Paket',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextFormField(
                              controller: namaPaketCtrl,
                              decoration: InputDecoration(
                                hintStyle: const TextStyle(fontSize: 14),
                                hintText:'Masukan nama paket',
                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: _validate,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nama Wisata',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            DropdownButtonFormField(
                              icon: const Icon(Icons.arrow_drop_down_rounded),
                                elevation: 16,
                                style: const TextStyle(color: Colors.black),
                                onChanged: (String? newValue) {
                                  setState(() {namaWisataCtrl = newValue;});
                                },
                                items: namaWisatas
                                .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              value : widget.type == "update"
                              ? upWisata()
                              : null,
                              hint: widget.type == "update"
                              ? Text(upWisata()?? "")
                              : null
                            ),
                          ],
                        ), 
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nama Penginapan',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            DropdownButtonFormField(
                              icon: const Icon(Icons.arrow_drop_down_rounded),
                                elevation: 16,
                                style: const TextStyle(color: Colors.black),
                                onChanged: (String? newValue) {
                                  setState(() {namaPenginapanCtrl = newValue;});
                                },
                                items: namaPenginapans
                                .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(), 
                              value: widget.type == "update"
                              ? upPenginapan()
                              : null,
                              hint: widget.type == "update"
                              ? Text(upPenginapan()?? "")
                              : null
                            ),
                          ],
                        ),   
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Harga',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextFormField(
                              controller: hargaCtrl,
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(fontSize: 14),
                                hintText: 'Masukkan harga paket',
                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: _validate,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Deskripsi',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextFormField(
                              controller: deskripsiCtrl,
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(fontSize: 14),
                                hintText: 'Tuliskan deskripsi paket disini',
                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: _validate,
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            _paket(namaPaketCtrl.text, hargaCtrl.text, deskripsiCtrl.text, namaPenginapanCtrl, namaWisataCtrl, user['id']);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black87,
                            minimumSize: const Size(double.infinity, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          child: const Text('SAVE'),
                        ),
                        const SizedBox(height: 10),
                        
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ]
      ),
    );
    
  }
}