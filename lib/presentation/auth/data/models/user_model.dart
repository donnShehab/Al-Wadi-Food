// import 'package:alwadi_food/presentation/auth/domain/entites/user_entity.dart';

// class UserModel extends UserEntity {
//   const UserModel({
//     required super.uid,
//     required super.name,
//     required super.email,
//     required super.role,
//     super.line,
//     required super.createdAt,
//     required super.updatedAt,
//     super.isActive = true,
//   });

//   // Convert Firestore JSON → Model
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       uid: json['uid'],
//       name: json['name'],
//       email: json['email'],
//       role: json['role'],
//       line: json['line'],
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//       isActive: json['isActive'] ?? true,
//     );
//   }

//   // Convert Model → JSON (for Firestore)
//   Map<String, dynamic> toJson() {
//     return {
//       'uid': uid,
//       'name': name,
//       'email': email,
//       'role': role,
//       'line': line,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//       'isActive': isActive,
//     };
//   }
// }
import 'package:alwadi_food/presentation/auth/domain/entites/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.role,
    super.line,
    required super.createdAt,
    required super.updatedAt,
    super.isActive = true,
  });

  // --------------------------------------------------------------------
  // Factory: Convert Firestore JSON → Model
  // Supports:
  // - Firestore Timestamp
  // - ISO String date
  // --------------------------------------------------------------------
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      line: json['line'],

      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),

      isActive: json['isActive'] ?? true,
    );
  }

  // Safe parser for DateTime or Timestamp
  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();

    if (value is Timestamp) return value.toDate();

    if (value is String) return DateTime.parse(value);

    throw Exception("Invalid date format: $value");
  }

  // --------------------------------------------------------------------
  // Convert Model → JSON (for Firestore)
  // --------------------------------------------------------------------
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'line': line,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  // --------------------------------------------------------------------
  // Convert Entity → Model (useful for Repository)
  // --------------------------------------------------------------------
  factory UserModel.fromEntity(UserEntity user) {
    return UserModel(
      uid: user.uid,
      name: user.name,
      email: user.email,
      role: user.role,
      line: user.line,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      isActive: user.isActive,
    );
  }
}
