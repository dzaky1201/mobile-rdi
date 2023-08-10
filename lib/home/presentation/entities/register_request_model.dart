import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_request_model.freezed.dart';

@unfreezed
abstract class RegisterRequestModel with _$RegisterRequestModel {
  factory RegisterRequestModel({
    required String name,
    required String email,
    required String password,
  }) = _RegisterRequestModel;
}