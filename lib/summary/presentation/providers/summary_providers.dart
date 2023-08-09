import 'package:cashflow_rdi/period/repository/period_repository.dart';
import 'package:cashflow_rdi/summary/entities/summary_model.dart';
import 'package:cashflow_rdi/summary/repository/summary_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../period/entities/period_model.dart';

var summaryRepositoryProvider = Provider(
  (ref) => SummaryRepository(),
);

var periodRepositoryProvider = Provider(
      (ref) => PeriodRepository(),
);

var summaryProvider = FutureProvider.autoDispose
    .family<SummaryResponse, String>((ref, year) async {
  var summary = ref.watch(summaryRepositoryProvider).fetchReportActivity(year);
  return summary;
});

var getPeriodProvider = FutureProvider<PeriodResponse>((ref) async {
  var summary = ref.watch(periodRepositoryProvider).fetchPeriod();
  return summary;
});
