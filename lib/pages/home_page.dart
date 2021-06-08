import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telegram_app/widgets/connectivity_widget.dart';
import 'package:telegram_app/extensions/user_display_name_initials.dart';

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
        child: ListView(
          children: [
            _accountHeader(context),
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
}
