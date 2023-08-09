class SummaryDataObject {
  final List<AllData> allData;

  const SummaryDataObject(
      {required this.allData});

  factory SummaryDataObject.fromJson(Map<String, dynamic> json){
    return SummaryDataObject(allData: (json['allData'] as List).map((data)=>AllData.fromJson(data)).toList());
  }
}

class SummaryResponse {
  final int code;
  final String status;
  final SummaryDataObject data;

  const SummaryResponse(
      {required this.code, required this.status, required this.data});

  factory SummaryResponse.fromJson(Map<String, dynamic> json){
    return SummaryResponse(
        code: json['code'], status: json['status'], data: SummaryDataObject.fromJson(json['data']));
  }
}

class AllData{
  final String month;
  final int total;

  const AllData(
      {required this.month, required this.total});

  factory AllData.fromJson(Map<String, dynamic> json){
    return AllData(month: json['month'], total: json['total']);
  }
}