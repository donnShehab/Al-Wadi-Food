import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String role;
  final String? line;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.line,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });
  UserEntity copyWith({
    String? uid,
    String? name,
    String? email,
    String? role,
    String? line,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      line: line ?? this.line,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
    uid,
    name,
    email,
    role,
    line,
    createdAt,
    updatedAt,
    isActive,
  ];
}
