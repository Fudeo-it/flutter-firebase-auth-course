import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


abstract class ConnectivityWidget extends StatelessWidget {
  const ConnectivityWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => OfflineBuilder(
        connectivityBuilder: (context, connectivity, child) =>
            connectivity == ConnectivityResult.none
                ? disconnectedBuild(context)
                : child,
        child: connectedBuild(context),
      );

  Widget connectedBuild(BuildContext context);

  Widget disconnectedBuild(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off,
                size: 128,
                color: Colors.grey,
              ),
              Text(AppLocalizations.of(context)?.label_no_connection_msg1 ?? ''),
              Text(AppLocalizations.of(context)?.label_no_connection_msg2 ?? ''),
              Padding(
                padding: EdgeInsets.only(top: 24),
                child: ElevatedButton(
                  onPressed: () => AppSettings.openDataRoamingSettings(),
                  child: Text(AppLocalizations.of(context)?.action_open_settings ?? ''),
                ),
              )
            ],
          ),
        ),
      );
}
