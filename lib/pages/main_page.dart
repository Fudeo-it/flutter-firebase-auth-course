import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegram_app/cubits/auth/auth_cubit.dart';
import 'package:telegram_app/pages/home_page.dart';
import 'package:telegram_app/pages/welcome_page.dart';
import 'package:telegram_app/widgets/connectivity_widget.dart';

class MainPage extends ConnectivityWidget {
  @override
  Widget connectedBuild(BuildContext context) =>
      BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) => state is LoadingAuthenticationState
            ? _loadingStateWidget()
            : state is AuthenticatedState
                ? HomePage(user: state.user)
                : WelcomePage(),
      );

  Widget _loadingStateWidget() => Scaffold(
        body: Container(),
      );
}
