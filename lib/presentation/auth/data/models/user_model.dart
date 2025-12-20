

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

  // ================= FROM JSON =================
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: (json['role'] as String).trim().toLowerCase(),
      line: json['line'],
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      isActive: json['isActive'] ?? true,
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.parse(value);
    throw Exception('Invalid date format');
  }

  // ================= TO JSON (Firestore) =================
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'line': line,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isActive': isActive,
    };
  }
    // ================= FROM ENTITY =================
  factory UserModel.fromEntity(UserEntity user) {
    return UserModel(
      uid: user.uid,
      name: user.name,
      email: user.email,
      role: user.role.trim().toLowerCase(),
      line: user.line,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      isActive: user.isActive,
    );
  }

}
