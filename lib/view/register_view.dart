import 'package:flutter/material.dart';
import 'package:kitago/constants.dart';
import 'package:kitago/datamodels/customer_dm.dart';
import 'package:kitago/datamodels/agent_dm.dart';
import 'package:kitago/services/blogservice.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  final String userType;
  const RegisterPage({Key? key, required this.userType}) : super(key: key);

  final String title = 'Register Page';
  static const routeName = "/registerPage";

  @override
  RegisterPageState createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _namaController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _extraController = new TextEditingController();
  TextEditingController _telpNumbController = new TextEditingController();
  
  late DateTime _selectedDate;
  late bool _isUpdating;

  @override
  void initState() {
    super.initState();
    _isUpdating = false;
    _formKey = GlobalKey();
    _scaffoldKey = GlobalKey();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _namaController = TextEditingController();
    _emailController = TextEditingController();
    _extraController = TextEditingController();
    _telpNumbController = TextEditingController();
  }

  // Now lets add an Customer
  _add() {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty || _namaController.text.isEmpty ||
    _emailController.text.isEmpty || _extraController.text.isEmpty || _telpNumbController.text.isEmpty) {
      print('Empty Fields');
      return;
    }
    APIService.add( _usernameController.text, _passwordController.text, _namaController.text,
    _emailController.text, _telpNumbController.text, _extraController.text, widget.userType)
        .then((result) {
      if ('success' == result) {
        Navigator.pushNamed(context, '/loginPage');
      }
    });
  }

  _update(int id) {
    setState(() {
      _isUpdating = true;
    });
    APIService.update(
            id, _usernameController.text, _passwordController.text, _namaController.text,
    _emailController.text, _telpNumbController.text, _extraController.text, widget.userType)
        .then((result) {
      if ('success' == result) {
        setState(() {
          _isUpdating = false;
        });
        Navigator.pushNamed(context, '/loginPage');
      }
    });
  }

  String? _validate(value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    }
    return null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _selectedDate = picked;
        _extraController
        ..text = DateFormat('yyyy-MM-dd').format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _extraController.text.length,
            affinity: TextAffinity.upstream));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/cover-login.png'),
                fit: BoxFit.cover,
                opacity: 0.5,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(50),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Register',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userType == 'agent'
                            ? 'Nama Penyedia Jasa'
                            : 'Nama Lengkap',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: _namaController,
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(fontSize: 14),
                          hintText: widget.userType == 'agent'
                              ? 'Masukkan Nama Agen'
                              : 'Masukkan Nama Lengkap',
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
                        'Email',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(fontSize: 14),
                          hintText: 'Masukkan Email',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: _validate,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (widget.userType == 'agent') ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Alamat',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          controller: _extraController,
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(fontSize: 14),
                            hintText: 'Masukkan Alamat Kantor',
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: _validate,
                        ),
                      ],
                    ),
                  ],
                  if (widget.userType == 'traveller') ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Birth Date',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: TextFormField(
                                controller: _extraController,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: _extraController.text.isNotEmpty
                                          ? Colors.black
                                          : Colors.grey),
                                  hintText: _extraController.text.isNotEmpty
                                      ? _extraController.text
                                      : 'hh/bb/tttt',
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: _validate,
                                enabled: false,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_calendar),
                              tooltip: 'Pick date',
                              onPressed: () => _selectDate(context),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Telephone Number',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: _telpNumbController,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(fontSize: 14),
                          hintText: 'Masukkan Nomor',
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
                        'Username',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(fontSize: 14),
                          hintText: 'Masukkan Username',
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
                        'Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(fontSize: 14),
                          hintText: 'Masukkan Password',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: _validate,
                        obscureText: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {_add();},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black87,
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: const Text('REGISTER'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Have not signed in yet?"),
                      TextButton(
                        onPressed: () =>
                            {Navigator.pushNamed(context, '/loginPage')},
                        style: TextButton.styleFrom(primary: Colors.black87),
                        child: const Text(
                          'Login Now!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
