part of 'signup_cubit.dart';

@immutable
abstract class SignupState {}

class SignupCubitInitial extends SignupState {}

class SignupCubitLoading extends SignupState {}

class SignupCubitSuccess extends SignupState {
  final UserEntity userEntity;

  SignupCubitSuccess({required this.userEntity});
}

class SignupCubitFailure extends SignupState {
  final String message;

  SignupCubitFailure({required this.message});
}
