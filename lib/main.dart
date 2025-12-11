// import 'package:alwadi_food/core/helper_functions/app_router.dart';
// import 'package:alwadi_food/core/services/get_it_service.dart';
// import 'package:alwadi_food/core/services/shared_preferences_singleton.dart';
// import 'package:alwadi_food/firebase_options.dart';
// import 'package:alwadi_food/generated/l10n.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//     await Prefs.init();

//   setupGetIt();

//   runApp(const AlWadiFood());
// }

// class AlWadiFood extends StatelessWidget {
//   const AlWadiFood({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       debugShowCheckedModeBanner: false,
//       locale: Locale('en'), // add laungauge
//       routerConfig: AppRouter.router,
//       localizationsDelegates: [
//         S.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       supportedLocales: S.delegate.supportedLocales,
//     );
//   }
// }

//QC
import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/core/localization/app_localizations.dart';
import 'package:alwadi_food/core/router/app_router.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';
import 'package:alwadi_food/presentation/settings/cubit/app_settings_cubit.dart';
import 'package:alwadi_food/presentation/settings/cubit/app_settings_state.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupDependencies();

  runApp(const MyApp());
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<AppSettingsCubit>(
//     create:
//     (_) => getIt<AppSettingsCubit>()..load(),

//     child:
//     BlocBuilder<AppSettingsCubit, AppSettingsState>(
//       builder: (context, state) {
//         return MaterialApp.router(
//           title: 'IceBox Factory Manager',

//           debugShowCheckedModeBanner: false,
//           theme: lightTheme,
//           darkTheme: darkTheme,
//           themeMode: state.themeMode,
//           locale: state.locale,
//           supportedLocales: AppLocalizations.supportedLocales,
//           localizationsDelegates: const [
//             AppLocalizations.delegate,
//             // If you later add flutter_localizations, include its delegates here
//           ],
//           routerConfig: appRouter,
//         );
//       },
//     )
//     );
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppSettingsCubit>(
          create: (_) => getIt<AppSettingsCubit>()..load(),
        ),

        BlocProvider<AuthCubit>(create: (_) => getIt<AuthCubit>()..checkAuthStatus()),
      ],
      child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'AlWadi Smart Factory',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: state.themeMode,
            locale: state.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [AppLocalizations.delegate],
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
