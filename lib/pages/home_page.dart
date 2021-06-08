import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telegram_app/cubits/auth/auth_cubit.dart';
import 'package:telegram_app/extensions/user_display_name_initials.dart';
import 'package:telegram_app/widgets/connectivity_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends ConnectivityWidget {
  final User user;

  HomePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget connectedBuild(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)?.app_name ?? ''),
        ),
        drawer: _drawer(context),
        body: Container(),
      );

  Widget _drawer(BuildContext context) => Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _accountHeader(context),
                ],
              ),
            ),
            Divider(height: 0),
            _logoutButton(context),
          ],
        ),
      );

  Widget _accountHeader(BuildContext context) => UserAccountsDrawerHeader(
        accountName: user.displayName != null ? Text(user.displayName!) : null,
        accountEmail: user.email != null ? Text(user.email!) : null,
        currentAccountPicture: CircleAvatar(
          backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
              ? Colors.blue
              : Colors.white,
          child: user.displayName != null
              ? Text(
                  user.displayNameInitials,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )
              : Container(),
        ),
      );

  Widget _logoutButton(BuildContext context) => ListTile(
        leading: Icon(Icons.logout),
        title: Text(AppLocalizations.of(context)?.action_logout ?? ''),
        onTap: () => _showLogoutDialog(context),
      );

  void _showLogoutDialog(BuildContext context) {
    if (WidgetsBinding.instance != null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title:
                Text(AppLocalizations.of(context)?.dialog_logout_title ?? ''),
            content:
                Text(AppLocalizations.of(context)?.dialog_logout_message ?? ''),
            actions: [
              TextButton(
                onPressed: () {
                  context.read<AuthCubit>().signOut();
                  context.router.pop();
                },
                child: Text(AppLocalizations.of(context)?.action_yes ?? ''),
              ),
              TextButton(
                onPressed: () => context.router.pop(),
                child: Text(AppLocalizations.of(context)?.action_no ?? ''),
              ),
            ],
          ),
        );
      });
    }
  }
}
