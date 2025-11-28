  import 'package:alwadi_food/core/helper_functions/app_router.dart';
  import 'package:alwadi_food/core/services/get_it_service.dart';
  import 'package:alwadi_food/core/services/shared_preferences_singleton.dart';
  import 'package:alwadi_food/firebase_options.dart';
  import 'package:alwadi_food/generated/l10n.dart';
  import 'package:firebase_core/firebase_core.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_localizations/flutter_localizations.dart';

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      await Prefs.init();

    setupGetIt();

    runApp(const AlWadiFood());
  }

  class AlWadiFood extends StatelessWidget {
    const AlWadiFood({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        locale: Locale('en'), // add laungauge
        routerConfig: AppRouter.router,
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
      );
    }
  }
