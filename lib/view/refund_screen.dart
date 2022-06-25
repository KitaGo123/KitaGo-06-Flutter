import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kitago/services/blogservice.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CustomBoxShadow extends BoxShadow {
  final BlurStyle blurStyle;

  const CustomBoxShadow({
    Color color = const Color(0xFF000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
    this.blurStyle = BlurStyle.normal,
  }) : super(color: color, offset: offset, blurRadius: blurRadius);

  @override
  Paint toPaint() {
    final Paint result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(blurStyle, blurSigma);
    assert(() {
      if (debugDisableShadows) {
        result.maskFilter = null;
      }
      return true;
    }());
    return result;
  }
}

class RefundScreen extends StatefulWidget {
  RefundScreen({Key? key, required this.id}) : super(key: key);
  
  int id;

  @override
  RefundScreenState createState() {
    return RefundScreenState();
  }
}

class RefundScreenState extends State<RefundScreen> {
  final _formKey = GlobalKey<FormState>();

  final idCtrl = TextEditingController();
  final alasanCtrl = TextEditingController();
  final dateCtrl = TextEditingController();

  dynamic user;

  @override
  void initState() {
    super.initState();
    getUser();
    dateCtrl
      .text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    idCtrl.text = widget.id.toString();
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user = json.decode(prefs.getString('user')!);
    });
  }

  _refund() async {
    await APIService.refund(int.parse(idCtrl.text), int.parse(user['id']), dateCtrl.text, alasanCtrl.text);
    Navigator.pushNamed(context, '/traveller');
  }

  String? _validate(value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 250,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/cover-booking.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  decoration:
                      BoxDecoration(color: Colors.white.withOpacity(0.4)),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(40),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: const [
                CustomBoxShadow(
                  color: Colors.black26,
                  offset: Offset(5.0, 5.0),
                  blurRadius: 5.0,
                  blurStyle: BlurStyle.outer,
                )
              ],
            ),
            child: Form(
              key: _formKey,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 20.0,
                children: [
                  const Text(
                    'Refund',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ID Booking',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: idCtrl,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(fontSize: 14),
                          hintText: 'Masukkan ID Booking',
                        ),
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
                        'Date Refund',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: dateCtrl,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(fontSize: 14),
                          hintText: 'Masukkan Tanggal Refund',
                        ),
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
                        'Alasan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: alasanCtrl,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(fontSize: 14),
                          hintText: 'Tuliskan alasan Anda',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: _validate,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {_refund();},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black87,
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: const Text('Refund'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
