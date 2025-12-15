
// import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';
// import 'package:alwadi_food/presentation/auth/cubit/auth_State.dart';
// import 'package:alwadi_food/presentation/home/cubit/home_cubit.dart';
// import 'package:alwadi_food/presentation/home/cubit/home_state.dart';
// import 'package:alwadi_food/presentation/home/presentation/views/widgets/home_skeleton.dart';
// import 'package:alwadi_food/presentation/home/presentation/views/widgets/home_view_body_content.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class HomeViewBodyBlocConsumer extends StatelessWidget {
//   const HomeViewBodyBlocConsumer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthCubit, AuthState>(
//       builder: (context, authState) {
//         if (authState is! AuthSuccess) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final user = authState.user; // ✅ المصدر الوحيد

//         return BlocBuilder<HomeCubit, HomeState>(
//           builder: (context, homeState) {
//                 debugPrint(
//               '👀 HomeState: $homeState | Cubit: ${context.read<HomeCubit>().hashCode}',
//             );
//             if (homeState is HomeInitial) {
//               // context.read<HomeCubit>().loadStats(); // ✅ بدون user
//             }

//             if (homeState is HomeLoading) {
//               return const HomeSkeleton();
//             }

//             if (homeState is HomeFullyLoaded) {
//               return HomeViewBodyContent(
//                 user: user, // 👈 من AuthCubit
//                 totalBatches: homeState.totalBatches,
//                 passedQC: homeState.passedQC,
//                 issues: homeState.issues,
//               );
//             }

//             // if (homeState is HomeError) {
//             //   return Center(child: Text(homeState.message));
//             // }
//             if (homeState is HomeError) {
//               return Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text('Unable to load data'),
//                     const SizedBox(height: 12),
//                     ElevatedButton(
//                       onPressed: () {
//                         context.read<HomeCubit>().loadStats();
//                       },
//                       child: const Text('Retry'),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             return const HomeSkeleton();
//           },
//         );
//       },
//     );
//   }
// }
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
