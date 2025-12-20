import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/core/localization/app_localizations.dart';
import 'package:alwadi_food/core/router/app_router.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';
import 'package:alwadi_food/presentation/home/cubit/home_cubit.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_dashboard/qc_dashboard_cubit.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(create: (_) => getIt<HomeCubit>()),

        BlocProvider<AuthCubit>(
          create: (_) => getIt<AuthCubit>()..checkAuthStatus(),
        ),
        BlocProvider<QCDashboardCubit>(
          create: (_) => getIt<QCDashboardCubit>()..loadDashboard(),
        ),
        BlocProvider<AppSettingsCubit>(
          create: (_) => getIt<AppSettingsCubit>()..load(),
        ),
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
