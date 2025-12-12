
// import 'package:alwadi_food/presentation/auth/domain/entites/user_entity.dart';
// import 'package:equatable/equatable.dart';

// sealed class HomeState extends Equatable {
//   const HomeState();

//   @override
//   List<Object?> get props => [];
// }

// /// الحالة الابتدائية
// class HomeInitial extends HomeState {
//   const HomeInitial();
// }

// /// حالة التحميل (نستخدمها لما نجيب البيانات من Firebase)
// class HomeLoading extends HomeState {
//   const HomeLoading();
// }

// /// حالة النجاح: فيها المستخدم + الإحصائيات
// class HomeLoaded extends HomeState {
//   final UserEntity user;
//   final int totalBatches;
//   final int passedQC;
//   final int issues;

//   const HomeLoaded({
//     required this.user,
//     required this.totalBatches,
//     required this.passedQC,
//     required this.issues,
//   });

//   @override
//   List<Object?> get props => [user, totalBatches, passedQC, issues];

//   /// لو حبيت تعدل جزء من الداتا لاحقاً (مثلاً الإحصائيات فقط)
//   HomeLoaded copyWith({
//     UserEntity? user,
//     int? totalBatches,
//     int? passedQC,
//     int? issues,
//   }) {
//     return HomeLoaded(
//       user: user ?? this.user,
//       totalBatches: totalBatches ?? this.totalBatches,
//       passedQC: passedQC ?? this.passedQC,
//       issues: issues ?? this.issues,
//     );
//   }
// }

// /// حالة الخطأ
// class HomeError extends HomeState {
//   final String message;

//   const HomeError(this.message);

//   @override
//   List<Object?> get props => [message];
// }
import 'package:equatable/equatable.dart';
import 'package:alwadi_food/presentation/auth/domain/entites/user_entity.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// INITIAL
class HomeInitial extends HomeState {
  const HomeInitial();
}

/// LOADING ANY DATA
class HomeLoading extends HomeState {
  const HomeLoading();
}

/// WHEN USER LOADED ONLY
class HomeUserLoaded extends HomeState {
  final UserEntity user;
  const HomeUserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

/// WHEN USER + STATS ARE READY
class HomeFullyLoaded extends HomeState {
  final UserEntity user;
  final int totalBatches;
  final int passedQC;
  final int issues;

  const HomeFullyLoaded({
    required this.user,
    required this.totalBatches,
    required this.passedQC,
    required this.issues,
  });

  @override
  List<Object?> get props => [user, totalBatches, passedQC, issues];
}

/// ERROR
class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
