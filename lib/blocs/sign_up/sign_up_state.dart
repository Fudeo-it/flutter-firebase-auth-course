part of 'sign_up_bloc.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();
  
  @override
  List<Object?> get props => [];
}

class InitialSignUpState extends SignUpState {

}

class SigningUpState extends SignUpState {}

class SuccessSignUpState extends SignUpState {
  final UserCredential userCredential;

  SuccessSignUpState(this.userCredential);

  @override
  List<Object?> get props => [userCredential];
}

class ErrorSignUpState extends SignUpState {}
