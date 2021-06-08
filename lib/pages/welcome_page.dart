import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:telegram_app/cubits/welcome_cubit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:telegram_app/router/app_router.gr.dart';


class WelcomePage extends StatelessWidget {
  @override
  Widget build(_) => _welcomeCubit(
        child: LayoutBuilder(
          builder: (context, _) => Scaffold(
            body: Container(
              padding: EdgeInsets.all(32),
              width: double.maxFinite,
              child: Column(
                children: [
                  _sliderContainer(context),
                  _startMessagingButton(context),
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
            ),
          ),
        ),
      );

  Widget _welcomeCubit({required Widget child}) => BlocProvider(
        create: (_) => WelcomeCubit(),
        child: child,
      );

  Widget _sliderContainer(BuildContext context) => Expanded(
        child: Column(
          children: [
            _slides(context),
            _indicator(),
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      );

  Widget _slides(BuildContext context) {
    final widgets = _items(context)
        .map(
          (item) => Container(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: item['image'],
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Text(
                          item['header'],
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            item['description'],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList(growable: false);

    return Container(
      height: 300,
      child: PageView.builder(
        itemBuilder: (context, index) => widgets[index],
        itemCount: widgets.length,
        controller: context.read<WelcomeCubit>().controller,
      ),
    );
  }

  Widget _indicator() => BlocBuilder<WelcomeCubit, int>(
        builder: (context, page) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _items(context).length,
            (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 3),
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                  color: page == index
                      ? Color(0xFF256075)
                      : Color(0xFF256075).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      );

  Widget _startMessagingButton(BuildContext context) => ElevatedButton(
      onPressed: () => context.router.push(SignInRoute()),
      child: Text(AppLocalizations.of(context)?.action_start_chatting ?? ''));

  List _items(BuildContext context) => [
        {
          "image": FaIcon(
            FontAwesomeIcons.telegram,
            color: Colors.cyan,
            size: 128,
          ),
          "header": AppLocalizations.of(context)?.welcome_header_1,
          "description": AppLocalizations.of(context)?.welcome_description_1,
        },
        {
          "image": FaIcon(
            FontAwesomeIcons.rocketchat,
            color: Colors.red,
            size: 128,
          ),
          "header": AppLocalizations.of(context)?.welcome_header_2,
          "description": AppLocalizations.of(context)?.welcome_description_2,
        },
        {
          "image": FaIcon(
            FontAwesomeIcons.commentDollar,
            color: Colors.green,
            size: 128,
          ),
          "header": AppLocalizations.of(context)?.welcome_header_3,
          "description": AppLocalizations.of(context)?.welcome_description_3,
        },
        {
          "image": FaIcon(
            FontAwesomeIcons.tachometerAlt,
            color: Colors.red,
            size: 128,
          ),
          "header": AppLocalizations.of(context)?.welcome_header_4,
          "description": AppLocalizations.of(context)?.welcome_description_4,
        },
        {
          "image": FaIcon(
            FontAwesomeIcons.lock,
            color: Colors.orange,
            size: 128,
          ),
          "header": AppLocalizations.of(context)?.welcome_header_5,
          "description": AppLocalizations.of(context)?.welcome_description_5,
        },
        {
          "image": FaIcon(
            FontAwesomeIcons.cloud,
            color: Colors.grey,
            size: 128,
          ),
          "header": AppLocalizations.of(context)?.welcome_header_6,
          "description": AppLocalizations.of(context)?.welcome_description_6,
        },
      ];
}
