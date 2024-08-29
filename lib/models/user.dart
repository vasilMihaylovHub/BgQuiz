import 'package:equatable/equatable.dart';

class ProfileUser extends Equatable {
  final String email;
  final String name;
  final String? password;

  const ProfileUser({ required this.email, required this.name, this.password});

  @override
  List<Object?> get props => [email, name, password];
}