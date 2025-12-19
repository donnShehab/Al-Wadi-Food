
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_State.dart';
import 'package:alwadi_food/presentation/home/presentation/views/widgets/home_view_body_content.dart';

class HomeViewBodyBlocConsumer extends StatelessWidget {
  const HomeViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthSuccess) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        /// ✅ المستخدم من AuthCubit فقط
        final user = authState.user;

        /// ❗ الأرقام لم تعد تُمرر من هنا
        /// المصدر الحقيقي للأرقام هو ProductionCubit داخل HomeViewBodyContent
        return HomeViewBodyContent(
          user: user,
          totalBatches: 0,
          passedQC: 0,
          issues: 0,
        );
      },
    );
  }
}
