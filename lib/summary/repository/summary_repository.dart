

import 'dart:convert';
import 'dart:developer';

import 'package:cashflow_rdi/period/entities/period_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/summary_model.dart';
import 'package:http/http.dart' as http;

class SummaryRepository{

  Future<SummaryResponse> fetchReportActivity(String year) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(
          'https://test.rumahdermawan.com/api/v1/activity/report?year=$year'),
      headers: <String, String>{
        'Authorization': 'Bearer ${prefs.getString("token")}'
      },
    );
    if (response.statusCode == 200) {
      return SummaryResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }
}