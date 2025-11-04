import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String username;
  final String email;
  final String? token;
  final String? firstName;
  final String? lastName;

  const User({
    required this.id,
    required this.username,
    required this.email,
    this.token,
    this.firstName,
    this.lastName,
  });

  @override
  List<Object?> get props => [id, username, email, token, firstName, lastName];
}
