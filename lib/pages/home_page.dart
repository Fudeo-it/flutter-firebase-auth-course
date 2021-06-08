import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telegram_app/widgets/connectivity_widget.dart';

class HomePage extends ConnectivityWidget {

  final User user;

  HomePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget connectedBuild(BuildContext context) => Scaffold(
        body: Container(),
      );
}
