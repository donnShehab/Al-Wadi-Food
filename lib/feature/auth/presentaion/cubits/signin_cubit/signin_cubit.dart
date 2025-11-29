import 'package:alwadi_food/core/errors/failures.dart';
import 'package:alwadi_food/feature/auth/domain/entites/user_entity.dart';
import 'package:alwadi_food/feature/auth/domain/repos/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit(this.authRepo) : super(SigninInitial());
  final AuthRepo authRepo;
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    print("SIGNIN START");
    emit(SigninLoading());
    final result = await authRepo.signInWithEmailAndPassword(email, password);
    result.fold(
      ifLeft: (failure) {
        print("SIGNIN FAILED: ${failure.message}");
        emit(SigninFailure(message: failure.message));
      },
      ifRight: (userEntity) {
        print("SIGNIN SUCCESS");
        emit(SigninSuccess(userEntity: userEntity));
      },
    );
   
  }
   Future<void> signInWithGoogle() async {
    emit(SigninLoading());
    final result = await authRepo.signInWithGoogle();
    result.fold(
      ifLeft: (failure) {
        return emit(SigninFailure(message: failure.message));
      },
      ifRight: (UserEntity) {
        return emit(SigninSuccess(userEntity: UserEntity));
      },
    );
  }
}
