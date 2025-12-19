
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/presentation/production/domain/repos/production_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ProductionRepository _productionRepository;

  HomeCubit(this._productionRepository) : super(const HomeInitial());

 
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
