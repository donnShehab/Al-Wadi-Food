import 'package:flutter_bloc/flutter_bloc.dart';
import 'manager_nav_state.dart';

class ManagerNavCubit extends Cubit<ManagerNavState> {
  ManagerNavCubit() : super(const ManagerNavInitial());

  void changeTab(int index) => emit(ManagerNavChanged(index));
}
