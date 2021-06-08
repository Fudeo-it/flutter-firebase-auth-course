import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegram_app/cubits/auth/auth_cubit.dart';
import 'package:telegram_app/cubits/dark_mode_cubit.dart';
import 'package:telegram_app/providers/shared_preferences_provider.dart';

class DependencyInjector extends StatelessWidget {
  final Widget child;

  const DependencyInjector({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => _providers(
        child: _blocs(
          child: child,
        ),
      );

  Widget _providers({required Widget child}) => MultiProvider(
        providers: [
          Provider<SharedPreferencesProvider>(
            create: (_) => SharedPreferencesProvider(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
          Provider<FirebaseAuth>(
            create: (_) => FirebaseAuth.instance,
          ),
          Provider<GoogleSignIn>(
            create: (_) => GoogleSignIn(scopes: [
              'https://www.googleapis.com/auth/userinfo.email',
              'https://www.googleapis.com/auth/userinfo.profile',
            ]),
          )
        ],
        child: child,
      );

  Widget _mappers({required Widget child}) => MultiProvider(
        providers: [],
        child: child,
      );

  Widget _repositories({required Widget child}) => MultiRepositoryProvider(
        providers: [],
        child: child,
      );

  Widget _blocs({required Widget child}) => MultiBlocProvider(
        providers: [
          BlocProvider<DarkModeCubit>(
            create: (context) => DarkModeCubit(
              preferencesProvider: context.read(),
            )..init(),
          ),
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(
              firebaseAuth: context.read(),
            ),
          ),
        ],
        child: child,
      );
}
