// import 'dart:convert';

// import 'package:e_coomerce_fruit/constants.dart';
// import 'package:e_coomerce_fruit/core/services/shared_preferences_singleton.dart';
// import 'package:e_coomerce_fruit/core/utils/app_images.dart';
// import 'package:e_coomerce_fruit/feature/auth/data/models/user_models.dart';
// import 'package:e_coomerce_fruit/feature/auth/domain/entites/user_entity.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// UserEntity getUser() {
//   var jsonString = Prefs.getString(kUserData);
//   var userEntity = UserModel.fromJson(jsonDecode(jsonString));
//   return userEntity;
// }

// String getUserEmail() {
//   final user = getUser(); // استرجاع المستخدم من shared preferences
//   return user.email; // إرجاع الإيميل من الكائن
// }

// String getUserProfileImage() {
//   final user = FirebaseAuth.instance.currentUser;

//   // إذا كان مستخدم مسجل في Firebase وبه صورة
//   if (user != null && user.photoURL != null && user.photoURL!.isNotEmpty) {
//     return user.photoURL!;
//   }

//   // إذا لم توجد صورة في Firebase، استخدم الصورة المحفوظة محلياً أو صورة افتراضية
//   return Prefs.getString('profile_image') != ''
//       ? Prefs.getString('profile_image')
//       : Image.asset(
//           Assets.imagesProfileImage,
//         ); // أو ضع رابط صورة افتراضية من الأصول
// }
