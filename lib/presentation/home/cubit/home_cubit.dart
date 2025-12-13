
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/presentation/production/domain/repos/production_repository.dart';
import 'home_state.dart';

// class HomeCubit extends Cubit<HomeState> {
//   final AuthRepository _authRepository;
//   final ProductionRepository _productionRepository;

//   HomeCubit(this._authRepository, this._productionRepository)
//     : super(const HomeInitial());

//   /// 🔹 STEP 1: Load User Only (لا تحميل إحصائيات الآن)
//   Future<void> loadUser() async {
//     emit(const HomeLoading());

//     final result = await _authRepository.getCurrentUser();

//     result.fold(
//       ifLeft: (failure) => emit(HomeError(failure.message)),
//       ifRight: (user) {
//         if (user == null) {
//           emit(const HomeError("User not found"));
//           return;
//         }

//         /// User is ready → emit simple user state
//         emit(HomeUserLoaded(user));
//       },
//     );
//   }

//   /// 🔹 STEP 2: Load Stats AFTER user is loaded
//   Future<void> loadStats(UserEntity user) async {
//     emit(const HomeLoading());

//     try {
//       final total = await _productionRepository.getTotalBatchesCount();
//       final passed = await _productionRepository.getPassedQCount();
//       final issues = await _productionRepository.getIssuesCount();

//       emit(
//         HomeFullyLoaded(
//           user: user,
//           totalBatches: total,
//           passedQC: passed,
//           issues: issues,
//         ),
//       );
//     } catch (e) {
//       emit(HomeError(e.toString()));
//     }
//   }

//   /// 🔹 Combined loader for Splash
//   Future<void> loadHome() async {
//     await loadUser();

//     if (state is HomeUserLoaded) {
//       final user = (state as HomeUserLoaded).user;
//       await loadStats(user);
//     }
//   }
// }
class HomeCubit extends Cubit<HomeState> {
  final ProductionRepository _productionRepository;

  HomeCubit(this._productionRepository) : super(const HomeInitial());

  /// HomeCubit مسؤول فقط عن الإحصائيات
  // Future<void> loadStats() async {
  //   emit(const HomeLoading());

  //   try {
  //     final total = await _productionRepository.getTotalBatchesCount();
  //     final passed = await _productionRepository.getPassedQCount();
  //     final issues = await _productionRepository.getIssuesCount();

  //     emit(
  //       HomeFullyLoaded(totalBatches: total, passedQC: passed, issues: issues),
  //     );
  //   } catch (e) {
  //     emit(HomeError(e.toString()));
  //   }
  // }
 
Future<void> loadStats() async {
    log('🔥 loadStats CALLED: $hashCode');

    emit(const HomeLoading());

    try {
      final total = await _productionRepository.getTotalBatchesCount();
      final passed = await _productionRepository.getPassedQCount();
      final issues = await _productionRepository.getIssuesCount();

      log('✅ loadStats SUCCESS: $hashCode');

      emit(
        HomeFullyLoaded(totalBatches: total, passedQC: passed, issues: issues),
      );
    } catch (e) {
      log('❌ loadStats ERROR: $e');
      emit(HomeError(e.toString()));
    }
  }



}
