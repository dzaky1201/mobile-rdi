import 'dart:convert';

import 'package:cashflow_rdi/summary/summary_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _SummaryPageView();
  }
}

class _SummaryPageView extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _SummaryPageView({Key? key}) : super(key: key);

  @override
  _SummaryPageViewState createState() => _SummaryPageViewState();
}

class _SummaryPageViewState extends State<_SummaryPageView> {
  late Future<SummaryResponse> futureReport;

  Future<SummaryResponse> fetchReportActivity() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(
          'https://test.rumahdermawan.com/api/v1/activity/report?year=2023'),
      headers: <String, String>{
        'Authorization': 'Bearer ${prefs.getString("token")}'
      },
    );
    debugPrint('responsenya : ${response.body}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return SummaryResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    futureReport = fetchReportActivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: const Row(
                      children: [
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: Text(
                            'Select Item',
                          ),
                        ),
                      ],
                    ),
                    items: items
                        .map((String item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (String? value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                        width: 100,
                        padding: const EdgeInsets.fromLTRB(5,0,5,0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(width: 1))
                    ),
                  ),
                ),
              ],
            ),
          ),
      FutureBuilder<SummaryResponse>(
          future: futureReport,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  // Chart title
                  title: ChartTitle(text: 'Ringkasan kas'),
                  // Enable legend
                  legend: const Legend(isVisible: true),
                  // Enable tooltip
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries<AllData, String>>[
                    LineSeries<AllData, String>(
                        dataSource: snapshot.data!.data.allData,
                        xValueMapper: (AllData data, _) => data.month,
                        yValueMapper: (AllData data, _) => data.total,
                        name: 'Ringkasan kas',
                        // Enable data label
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true))
                  ]);
            } else {
              return const CircularProgressIndicator();
            }
          }),
    ]));
  }
}
