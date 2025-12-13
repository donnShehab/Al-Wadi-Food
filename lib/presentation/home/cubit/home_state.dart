
// import 'package:equatable/equatable.dart';
// import 'package:alwadi_food/presentation/auth/domain/entites/user_entity.dart';

// sealed class HomeState extends Equatable {
//   const HomeState();

//   @override
//   List<Object?> get props => [];
// }

// /// INITIAL
// class HomeInitial extends HomeState {
//   const HomeInitial();
// }

// /// LOADING ANY DATA
// class HomeLoading extends HomeState {
//   const HomeLoading();
// }

// /// WHEN USER LOADED ONLY
// class HomeUserLoaded extends HomeState {
//   final UserEntity user;
//   const HomeUserLoaded(this.user);

//   @override
//   List<Object?> get props => [user];
// }

// /// WHEN USER + STATS ARE READY
// class HomeFullyLoaded extends HomeState {
//   final UserEntity user;
//   final int totalBatches;
//   final int passedQC;
//   final int issues;

//   const HomeFullyLoaded({
//     required this.user,
//     required this.totalBatches,
//     required this.passedQC,
//     required this.issues,
//   });

//   @override
//   List<Object?> get props => [user, totalBatches, passedQC, issues];
// }

// /// ERROR
// class HomeError extends HomeState {
//   final String message;
//   const HomeError(this.message);

//   @override
//   List<Object?> get props => [message];
// }
abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeFullyLoaded extends HomeState {
  final int totalBatches;
  final int passedQC;
  final int issues;

  const HomeFullyLoaded({
    required this.totalBatches,
    required this.passedQC,
    required this.issues,
  });
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
}
