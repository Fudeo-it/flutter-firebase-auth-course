import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_essentials_kit/flutter_essentials_kit.dart';
import 'package:rxdart/rxdart.dart';
import 'package:telegram_app/cubits/auth/auth_cubit.dart';
import 'package:telegram_app/repositories/authentication_repository.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthenticationRepository authenticationRepository;
  final AuthCubit authCubit;

  final firstNameBinding = TwoWayBinding<String>().bindDataRule(RequiredRule());

  final lastNameBinding = TwoWayBinding<String>().bindDataRule(RequiredRule());

  final emailBinding = TwoWayBinding<String>()
      .bindDataRule(RequiredRule())
      .bindDataRule(EmailRule());

  final passwordBinding = TwoWayBinding<String>().bindDataRule(RequiredRule());

  final confirmEmailBinding = TwoWayBinding<String>()
      .bindDataRule(RequiredRule())
      .bindDataRule(EmailRule());

  final confirmPasswordBinding =
      TwoWayBinding<String>().bindDataRule(RequiredRule());

  SignUpBloc({
    required this.authenticationRepository,
    required this.authCubit,
  }) : super(InitialSignUpState()) {
    confirmEmailBinding.bindDataRule2(emailBinding, SameRule());
    confirmPasswordBinding.bindDataRule2(passwordBinding, SameRule());
  }

  Stream<bool> get areValidCredentials => Rx.combineLatest(
        [
          firstNameBinding.stream,
          lastNameBinding.stream,
          emailBinding.stream,
          confirmEmailBinding.stream,
          passwordBinding.stream,
          confirmPasswordBinding.stream,
        ],
        (_) =>
            firstNameBinding.value != null &&
            firstNameBinding.value!.isNotEmpty &&
            lastNameBinding.value != null &&
            lastNameBinding.value!.isNotEmpty &&
            emailBinding.value != null &&
            emailBinding.value!.isNotEmpty &&
            confirmEmailBinding.value != null &&
            confirmEmailBinding.value!.isNotEmpty &&
            passwordBinding.value != null &&
            passwordBinding.value!.isNotEmpty &&
            confirmPasswordBinding.value != null &&
            confirmPasswordBinding.value!.isNotEmpty,
      );

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is PerformSignUpEvent) {
      yield SigningUpState();

      final authSubscription = authCubit.stream
          .where((state) => state is AuthenticatedState)
          .listen((state) =>
              _updateUserProfile(event, state: (state as AuthenticatedState)));

      UserCredential? userCredential;
      try {
        userCredential = await authenticationRepository.signUp(
          email: event.email,
          password: event.password,
        );
      } catch (error) {
        yield ErrorSignUpState();
      } finally {
        authSubscription.cancel();
      }

      if (userCredential != null) {
        yield SuccessSignUpState(userCredential);
      }
    }
  }

  void _updateUserProfile(
    PerformSignUpEvent event, {
    required AuthenticatedState state,
  }) async {
    final user = state.user;
    final firstName = event.firstName;
    final lastName = event.lastName;
    final displayName = '$firstName $lastName';

    await user.updateDisplayName(displayName);
  }

  @override
  Future<void> close() async {
    await firstNameBinding.close();
    await lastNameBinding.close();
    await emailBinding.close();
    await passwordBinding.close();
    await confirmEmailBinding.close();
    await confirmPasswordBinding.close();

    return super.close();
  }

  void performSignUp({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
  }) =>
      add(
        PerformSignUpEvent(
          firstName: (firstName ?? firstNameBinding.value) ?? '',
          lastName: (lastName ?? lastNameBinding.value) ?? '',
          email: (email ?? emailBinding.value) ?? '',
          password: (password ?? passwordBinding.value) ?? '',
        ),
      );
}
