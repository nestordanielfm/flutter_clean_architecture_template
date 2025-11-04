import 'package:json_annotation/json_annotation.dart';
import 'package:template_app/features/login/domain/entities/user.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  final int id;
  final String username;
  final String email;
  final String? token;
  final String? firstName;
  final String? lastName;

  AuthResponse({
    required this.id,
    required this.username,
    required this.email,
    this.token,
    this.firstName,
    this.lastName,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);

  User toEntity() {
    return User(
      id: id,
      username: username,
      email: email,
      token: token,
      firstName: firstName,
      lastName: lastName,
    );
  }
}
