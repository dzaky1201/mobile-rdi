import 'dart:developer';
import 'package:cashflow_rdi/period/entities/period_model.dart';
import 'package:cashflow_rdi/summary/entities/summary_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../providers/summary_providers.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SummaryPageView();
  }
}

class _SummaryPageView extends ConsumerStatefulWidget {
  const _SummaryPageView({Key? key}) : super(key: key);

  @override
  _SummaryPageViewState createState() => _SummaryPageViewState();
}

class _SummaryPageViewState extends ConsumerState<_SummaryPageView> {
  String? yearSelectedValue = DateTime.now().year.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        ref.watch(getPeriodProvider).when(
            data: (data) {
              if (data.data.isEmpty) {
                yearSelectedValue = '';
              }
              return Container(
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
                                'year',
                              ),
                            ),
                          ],
                        ),
                        items: data.data
                            .map(
                                (PeriodObject item) => DropdownMenuItem<String>(
                                      value: item.year,
                                      child: Text(
                                        item.year,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                            .toList(),
                        value: yearSelectedValue,
                        onChanged: (String? value) {
                          setState(() {
                            yearSelectedValue = value;
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                            width: 100,
                            height: 30,
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(width: 1))),
                      ),
                    ),
                  ],
                ),
              );
            },
            error: (error, _) => Text(error.toString()),
            loading: () =>
                const Visibility(visible: false, child: Text('Loading....'))),
        ref.watch(summaryProvider(yearSelectedValue!)).when(
            data: (data) {
              if (data.data.allData!.isNotEmpty) {
                return SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    // Chart title
                    title: ChartTitle(text: 'Data kas $yearSelectedValue'),
                    // Enable legend
                    legend: const Legend(isVisible: true),
                    // Enable tooltip
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <ChartSeries<AllData, String>>[
                      LineSeries<AllData, String>(
                          dataSource: data.data.allData!,
                          xValueMapper: (AllData data, _) => data.month,
                          yValueMapper: (AllData data, _) => data.total,
                          name: 'Data kas $yearSelectedValue',
                          // Enable data label
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: true))
                    ]);
              } else {
                return const Text('Tidak ada data');
              }
            },
            error: (error, _) => Text(error.toString()),
            loading: () => Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                alignment: Alignment.center,
                child: const Text('Loading....')))
      ]),
    ));
  }
}
