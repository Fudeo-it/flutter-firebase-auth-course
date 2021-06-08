part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class LoadingAuthenticationState extends AuthState {}

class AuthenticatedState extends AuthState {
  final User user;

  AuthenticatedState(this.user);

  @override
  List<Object?> get props => [user];
}

class NotAuthenticatedState extends AuthState {}
