import 'package:alwadi_food/feature/auth/domain/entites/user_entity.dart';
import 'package:alwadi_food/feature/auth/domain/repos/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'signup_state.dart';

// Presentation logic coordinator
// Cubit يستدعي Repo ثم يصدِر حالات جديدة.
class SignupCubit extends Cubit<SignupState> {
  SignupCubit(this.authRepo) : super(SignupCubitInitial());
  final AuthRepo authRepo;
  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
    String phoneNumber,
  ) async {
    emit(SignupCubitLoading());
    final result = await authRepo.createUserWithEmailAndPassword(
      email,
      password,
      name,
      phoneNumber,
    );
    result.fold(
      ifLeft: (failure) => emit(SignupCubitFailure(message: failure.message)),
      ifRight: (userEntity) => emit(SignupCubitSuccess(userEntity: userEntity)),
    );
  }
}
