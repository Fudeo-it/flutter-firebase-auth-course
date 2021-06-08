import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_essentials_kit/flutter_essentials_kit.dart';
import 'package:rxdart/rxdart.dart';
import 'package:telegram_app/repositories/authentication_repository.dart';

part 'sign_in_event.dart';

part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthenticationRepository authenticationRepository;

  final emailBinding = TwoWayBinding<String>()
      .bindDataRule(RequiredRule())
      .bindDataRule(EmailRule());
  final passwordBinding = TwoWayBinding<String>().bindDataRule(RequiredRule());

  SignInBloc({required this.authenticationRepository})
      : super(InitialSignInState());

  Stream<bool> get areValidCredentials => Rx.combineLatest2(
      emailBinding.stream,
      passwordBinding.stream,
      (_, __) =>
          emailBinding.value != null &&
          emailBinding.value!.isNotEmpty &&
          passwordBinding.value != null &&
          passwordBinding.value!.isNotEmpty);

  @override
  Stream<SignInState> mapEventToState(
    SignInEvent event,
  ) async* {
    if (event is PerformSignInEvent || event is PerformSignInWithGoogleEvent) {
      yield SigningInState();

      UserCredential? userCredential;

      try {
        userCredential = event is PerformSignInEvent
            ? await authenticationRepository.signIn(
                email: event.email,
                password: event.password,
              )
            : await authenticationRepository.signInWithGoogle();
      } catch (error) {
        yield ErrorSignInState();
      }

      if (userCredential != null) {
        yield SuccessSignInState(userCredential);
      }
    }
  }

  @override
  Future<void> close() async {
    await emailBinding.close();
    await passwordBinding.close();

    return super.close();
  }

  void performSignIn({
    String? email,
    String? password,
  }) =>
      add(
        PerformSignInEvent(
          email: (email ?? emailBinding.value) ?? '',
          password: (password ?? passwordBinding.value) ?? '',
        ),
      );

  void performSignInWithGoogle() => add(PerformSignInWithGoogleEvent());
}
