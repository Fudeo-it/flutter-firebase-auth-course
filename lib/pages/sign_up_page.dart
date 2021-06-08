import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_essentials_kit/flutter_essentials_kit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telegram_app/blocs/sign_up/sign_up_bloc.dart';
import 'package:telegram_app/widgets/connectivity_widget.dart';

class SignUpPage extends ConnectivityWidget implements AutoRouteWrapper {
  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider<SignUpBloc>(
        create: (context) => SignUpBloc(
          authenticationRepository: context.read(),
          authCubit: context.read(),
        ),
        child: this,
      );

  @override
  Widget connectedBuild(BuildContext context) =>
      BlocConsumer<SignUpBloc, SignUpState>(
          builder: (context, state) => Scaffold(
                appBar: AppBar(
                  title:
                      Text(AppLocalizations.of(context)?.title_sign_up ?? ''),
                ),
                body: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _firstNameField(context, enabled: state is! SigningUpState),
                    _lastNameField(context, enabled: state is! SigningUpState),
                    Divider(),
                    _emailField(context, enabled: state is! SigningUpState),
                    _confirmEmailField(context, enabled: state is! SigningUpState),
                    Divider(),
                    _passwordField(context, enabled: state is! SigningUpState),
                    _confirmPasswordField(context, enabled: state is! SigningUpState),
                    _signUpButton(context, enabled: state is! SigningUpState),
                    if (state is SigningUpState) _progress(),
                  ],
                ),
              ),
          listener: (context, state) {
            _shouldCloseForSignedUp(context, state: state);
            _shouldShowErrorSignUpDialog(context, state: state);
          });

  Widget _firstNameField(BuildContext context, {bool enabled = true}) =>
      TwoWayBindingBuilder<String>(
        binding: context.watch<SignUpBloc>().firstNameBinding,
        builder: (
          context,
          controller,
          data,
          onChanged,
          error,
        ) =>
            TextField(
          enabled: enabled,
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)?.label_first_name ?? '',
            errorText: error?.localizedString(context),
          ),
          keyboardType: TextInputType.name,
        ),
      );

  Widget _lastNameField(BuildContext context, {bool enabled = true}) =>
      TwoWayBindingBuilder<String>(
        binding: context.watch<SignUpBloc>().lastNameBinding,
        builder: (
          context,
          controller,
          data,
          onChanged,
          error,
        ) =>
            TextField(
          enabled: enabled,
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)?.label_last_name ?? '',
            errorText: error?.localizedString(context),
          ),
          keyboardType: TextInputType.name,
        ),
      );

  Widget _emailField(BuildContext context, {bool enabled = true}) =>
      TwoWayBindingBuilder<String>(
        binding: context.watch<SignUpBloc>().emailBinding,
        builder: (
          context,
          controller,
          data,
          onChanged,
          error,
        ) =>
            TextField(
          enabled: enabled,
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)?.label_email ?? '',
            errorText: error?.localizedString(context),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
      );

  Widget _confirmEmailField(BuildContext context, {bool enabled = true}) =>
      TwoWayBindingBuilder<String>(
        binding: context.watch<SignUpBloc>().confirmEmailBinding,
        builder: (
          context,
          controller,
          data,
          onChanged,
          error,
        ) =>
            TextField(
          controller: controller,
          onChanged: onChanged,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)?.label_email_confirm ?? '',
            errorText: error?.localizedString(context),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
      );

  Widget _passwordField(BuildContext context, {bool enabled = true}) =>
      TwoWayBindingBuilder<String>(
        binding: context.watch<SignUpBloc>().passwordBinding,
        builder: (
          context,
          controller,
          data,
          onChanged,
          error,
        ) =>
            TextField(
          enabled: enabled,
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)?.label_password ?? '',
            errorText: error?.localizedString(context),
          ),
          obscureText: true,
        ),
      );

  Widget _confirmPasswordField(BuildContext context, {bool enabled = true}) =>
      TwoWayBindingBuilder<String>(
        binding: context.watch<SignUpBloc>().confirmPasswordBinding,
        builder: (
          context,
          controller,
          data,
          onChanged,
          error,
        ) =>
            TextField(
          enabled: enabled,
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText:
                AppLocalizations.of(context)?.label_password_confirm ?? '',
            errorText: error?.localizedString(context),
          ),
          obscureText: true,
        ),
      );

  Widget _signUpButton(BuildContext context, {bool enabled = true}) {
    Widget _signUpButtonEnabled(
      BuildContext context, {
      required Widget Function(bool) function,
    }) =>
        StreamBuilder<bool>(
          initialData: false,
          stream: context.watch<SignUpBloc>().areValidCredentials,
          builder: (context, snapshot) =>
              function(enabled && snapshot.hasData && snapshot.data!),
        );

    return _signUpButtonEnabled(context,
        function: (enabled) => ElevatedButton(
              onPressed: enabled
                  ? () => context.read<SignUpBloc>().performSignUp()
                  : null,
              child: Text(AppLocalizations.of(context)?.action_sign_up ?? ''),
            ));
  }

  Widget _progress() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: CircularProgressIndicator()),
      );

  void _shouldShowErrorSignUpDialog(
    BuildContext context, {
    required SignUpState state,
  }) {
    if (WidgetsBinding.instance != null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (state is ErrorSignUpState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                  AppLocalizations.of(context)?.dialog_wrong_sign_up_title ??
                      ''),
              content: Text(
                  AppLocalizations.of(context)?.dialog_wrong_sign_up_message ??
                      ''),
              actions: [
                TextButton(
                    onPressed: () => context.router.pop(),
                    child: Text(AppLocalizations.of(context)?.action_ok ?? '')),
              ],
            ),
          );
        }
      });
    }
  }

  void _shouldCloseForSignedUp(
    BuildContext context, {
    required SignUpState state,
  }) {
    if (WidgetsBinding.instance != null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (state is SuccessSignUpState) {
          context.router.popUntilRoot();
        }
      });
    }
  }
}
