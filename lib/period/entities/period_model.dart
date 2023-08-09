class PeriodResponse {
  final int code;
  final String status;
  final List<PeriodObject> data;

  const PeriodResponse(
      {required this.code, required this.status, required this.data});

  factory PeriodResponse.fromJson(Map<String, dynamic> json) {
    return PeriodResponse(
        code: json['code'],
        status: json['status'],
        data: json['data'] != null
            ? (json['data'] as List)
                .map((data) => PeriodObject.fromJson(data))
                .toList()
            : []);
  }
}

class PeriodObject {
  final String year;

  const PeriodObject({required this.year});

  factory PeriodObject.fromJson(Map<String, dynamic> json) {
    return PeriodObject(year: json['year']);
  }
}
