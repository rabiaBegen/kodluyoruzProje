
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object> get props=> [];
}

class SignInRequested extends AuthEvent{
  final String email;
  final String password;

  const SignInRequested({required this.email,required this.password});

  @override
  List<Object> get props=>[email,password];
}

class SignUpRequested extends AuthEvent{
  final String kullaniciAdi;
  final String email;
  final String password;

  const SignUpRequested({required this.kullaniciAdi,required this.email,required this.password});

  @override
  List<Object> get props=>[kullaniciAdi,email,password];
}

class GoogleSignInRequested extends AuthEvent{}

class SignOutRequested extends AuthEvent{}

class ResetPasswordRequested extends AuthEvent{
  final String email;
  final String password;

  const ResetPasswordRequested({required this.email,required this.password});

  @override
  List<Object> get props=>[email];
}