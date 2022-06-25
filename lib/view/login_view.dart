import 'dart:ui';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kitago/datamodels/customer_dm.dart';
import 'package:kitago/datamodels/agent_dm.dart';
import 'package:kitago/services/blogservice.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  final String title = 'Login Page';
  static const routeName = "/loginPage";

  @override
  LoginScreenState createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _validate(value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    }
    return null;
  }

  _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      print('Empty Fields');
      return;
    }
    var user = await APIService.login(_usernameController.text, _passwordController.text);
    var userLog = json.decode(user);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', json.encode(userLog[0]));
    print(prefs.getString('user'));
    if (userLog.isNotEmpty) {
      if (userLog[0]['nama_lengkap'] != null) {
        return Navigator.pushNamed(context, '/traveller');
      } else if (userLog[0]['nama_penyedia_jasa'] != null) {
        return Navigator.pushNamed(context, '/agent');
      }
    } else {
      print("Username dan password tidak ditemukan");
      return;
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
                    'Login',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 40),
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
                    onPressed: () => _login(),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black87,
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: const Text('LOGIN'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account yet?"),
                      TextButton(
                        onPressed: () =>
                            {Navigator.pushNamed(context, '/registerPage/traveler')},
                        style: TextButton.styleFrom(primary: Colors.black87),
                        child: const Text(
                          'Register Now!',
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
