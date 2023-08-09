class LoginDataObject {
  final int id;
  final String email;
  final String token;

  const LoginDataObject(
      {required this.id, required this.email, required this.token});

  factory LoginDataObject.fromJson(Map<String, dynamic> json){
    return LoginDataObject(
        id: json['id'] ?? 0, email: json['email'] ?? "", token: json['token'] ?? "");
  }
}

class LoginResponse {
  final int code;
  final String status;
  final LoginDataObject data;

  const LoginResponse(
      {required this.code, required this.status, required this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json){
    return LoginResponse(
        code: json['code'], status: json['status'], data: LoginDataObject.fromJson(json['data']));
  }
}