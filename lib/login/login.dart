import 'dart:convert';
import 'package:cashflow_rdi/home/home_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_moodel.dart';
import 'package:http/http.dart' as http;

class LoginPages extends StatelessWidget {
  const LoginPages({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final passController = TextEditingController();
  final emailController = TextEditingController();

  Future<String?> setToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
    return prefs.getString("token");
  }

  final textFieldFocusNode = FocusNode();
  bool _obscured = true;
  bool _loading = false;
  String _email = '';
  String _password = '';
  Future<LoginResponse>? _loginResponse;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) {
        return; // If focus is on text field, dont unfocus
      }
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  @override
  void initState() {
    super.initState();

    passController.addListener(_getDataField);
    emailController.addListener(_getDataField);
  }

  Future<LoginResponse> loginAccount(String email, String password) async {
    final response = await http.post(
        Uri.parse("https://test.rumahdermawan.com/api/v1/user/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body:
            jsonEncode(<String, String>{'email': email, 'password': password}));
    if (response.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }

  @override
  void dispose() {
    passController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _getDataField() {
    setState(() {
      _email = emailController.text;
      _password = passController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                child: const Image(image: AssetImage("images/logo_fix.png")),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                padding: const EdgeInsets.all(10),
                child: const Text("Sistem keuangan rumah dermawan indonesia",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                padding: const EdgeInsets.all(10),
                child: const Text("Login",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center),
              ),
              Container(
                width: 300,
                margin: const EdgeInsets.fromLTRB(0, 18, 0, 0),
                child: TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Email',
                      label: Text('email')),
                  controller: emailController,
                ),
              ),
              Container(
                width: 300,
                margin: const EdgeInsets.fromLTRB(0, 18, 0, 0),
                child: TextField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscured,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'password',
                      label: const Text('password'),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                        child: GestureDetector(
                          onTap: _toggleObscured,
                          child: Icon(
                            _obscured
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            size: 24,
                          ),
                        ),
                      )),
                  controller: passController,
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    if (_email == '' || _password == '') {
                      const snackBar = SnackBar(
                        content: Text('Lengkapi Field data !'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      setState(() {
                        _loginResponse = loginAccount(_email, _password);
                        _loading = true;
                        _loginResponse?.then((data) => {
                              if (data.code == 200)
                                {
                                  setToken(data.data.token).then((value) => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomeLayout(loginData: data.data, token: value!)),
                                    )
                                  }),

                                }
                            });
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange),
                  child: const Text('Login'),
                ),
              ),
              Visibility(
                visible: _loading,
                child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: const CircularProgressIndicator(
                      color: Colors.deepOrange,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
