import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_essentials_kit/flutter_essentials_kit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:telegram_app/blocs/sign_in/sign_in_bloc.dart';
import 'package:telegram_app/router/app_router.gr.dart';
import 'package:telegram_app/widgets/connectivity_widget.dart';

class SignInPage extends ConnectivityWidget implements AutoRouteWrapper {
  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
        create: (context) => SignInBloc(
          authenticationRepository: context.read(),
        ),
        child: this,
      );

  @override
  Widget connectedBuild(_) => BlocConsumer<SignInBloc, SignInState>(
      builder: (context, state) => Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)?.title_sign_in ?? ''),
              automaticallyImplyLeading: false,
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _emailField(context, enabled: state is! SigningInState),
                _passwordField(context, enabled: state is! SigningInState),
                _signInButton(context, enabled: state is! SigningInState),
                if (state is! SigningInState) _orDivider(context),
                _googleLoginButton(context, enabled: state is! SigningInState),
                Divider(),
                _signUpButton(context, enabled: state is! SigningInState),
                if (state is SigningInState) _progress(),
              ],
            ),
          ),
      listener: (context, state) {
        _shouldCloseForSignedIn(context, state: state);
        _shouldShowErrorSignInDialog(context, state: state);
      });

  Widget _progress() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: CircularProgressIndicator()),
      );

  Widget _emailField(BuildContext context, {bool enabled = true}) =>
      TwoWayBindingBuilder<String>(
        binding: context.watch<SignInBloc>().emailBinding,
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
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)?.label_email,
            errorText: error?.localizedString(context),
          ),
        ),
      );

  Widget _passwordField(BuildContext context, {bool enabled = true}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TwoWayBindingBuilder<String>(
          binding: context.watch<SignInBloc>().passwordBinding,
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
            obscureText: true,
            decoration: InputDecoration(
                hintText: AppLocalizations.of(context)?.label_password,
                errorText: error?.localizedString(context)),
          ),
        ),
      );

  Widget _signInButton(BuildContext context, {bool enabled = true}) {
    Widget _signInButtonEnabled(
      BuildContext context, {
      required Widget Function(bool) function,
    }) =>
        StreamBuilder<bool>(
          initialData: false,
          stream: context.watch<SignInBloc>().areValidCredentials,
          builder: (context, snapshot) =>
              function(enabled && snapshot.hasData && snapshot.data!),
        );

    return _signInButtonEnabled(
      context,
      function: (enabled) => ElevatedButton(
        onPressed:
            enabled ? () => context.read<SignInBloc>().performSignIn() : null,
        child: Text(AppLocalizations.of(context)?.action_login ?? ''),
      ),
    );
  }

  Widget _orDivider(BuildContext context) {
    final divider = Expanded(child: Divider(height: 0));

    return Row(
      children: [
        divider,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            AppLocalizations.of(context)?.label_or ?? '',
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        divider,
      ],
    );
  }

  Widget _signUpButton(BuildContext context, {bool enabled = true}) =>
      ElevatedButton(
        onPressed: enabled ? () => context.router.push(SignUpRoute()) : null,
        child: Text(AppLocalizations.of(context)?.action_sign_up ?? ''),
      );

  Widget _googleLoginButton(BuildContext context, {bool enabled = true}) =>
      enabled
          ? SignInButton(
              Buttons.Google,
              onPressed: () => context.read<SignInBloc>().performSignInWithGoogle(),
            )
          : Container();

  void _shouldCloseForSignedIn(
    BuildContext context, {
    required SignInState state,
  }) {
    if (WidgetsBinding.instance != null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (state is SuccessSignInState) {
          context.router.popUntilRoot();
        }
      });
    }
  }

  void _shouldShowErrorSignInDialog(
    BuildContext context, {
    required SignInState state,
  }) {
    if (WidgetsBinding.instance != null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (state is ErrorSignInState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                  AppLocalizations.of(context)?.dialog_wrong_login_title ?? ''),
              content: Text(
                  AppLocalizations.of(context)?.dialog_wrong_login_message ??
                      ''),
              actions: [
                TextButton(
                  onPressed: () => context.router.pop(),
                  child: Text(AppLocalizations.of(context)?.action_ok ?? ''),
                ),
              ],
            ),
          );
        }
      });
    }
  }
}
