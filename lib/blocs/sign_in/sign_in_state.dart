part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  const SignInState();
  
  @override
  List<Object?> get props => [];
}

class InitialSignInState extends SignInState {
}

class SigningInState extends SignInState {}

class SuccessSignInState extends SignInState {
  final UserCredential userCredential;

  SuccessSignInState(this.userCredential);

  @override
  List<Object?> get props => [userCredential];
}

class ErrorSignInState extends SignInState {}
