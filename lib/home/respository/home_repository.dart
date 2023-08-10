import 'dart:convert';

import 'package:cashflow_rdi/home/presentation/entities/register_request_model.dart';
import 'package:http/http.dart' as http;
import '../../login/login_model.dart';

class HomeRepository {

  Future<LoginResponse> registerAccount(
      RegisterRequestModel body) async {
    final response = await http.post(
        Uri.parse("https://test.rumahdermawan.com/api/v1/user/register"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'name': body.name,
          'email': body.email,
          'password': body.password
        }));
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      return LoginResponse.fromJson(jsonDecode(response.body));
    }
  }
}
