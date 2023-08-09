

import 'dart:convert';
import 'dart:developer';

import 'package:cashflow_rdi/period/entities/period_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PeriodRepository{

  Future<PeriodResponse> fetchPeriod() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(
          'https://test.rumahdermawan.com/api/v1/period/years'),
      headers: <String, String>{
        'Authorization': 'Bearer ${prefs.getString("token")}'
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return PeriodResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }
}