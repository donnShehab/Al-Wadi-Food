import 'dart:developer';

import 'package:alwadi_food/core/errors/exceptions.dart';
import 'package:alwadi_food/core/errors/failures.dart';
import 'package:alwadi_food/feature/auth/domain/entites/user_entity.dart';
import 'package:dart_either/dart_either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw CustomException(message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw CustomException(
          message: 'The account already exists for that email.',
        );
      } else {
        throw CustomException(
          message: 'The account already exists for that email.',
        );
      }
    } catch (e) {
      throw CustomException(message: 'An error occurred. Please try later.');
    }
  }

  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log(
        "Exception in FirebaseAuthService.signInWithEmailAndPassword: ${e.toString()} and code is ${e.code}",
      );
      if (e.code == 'user-not-found') {
        throw CustomException(
          message: 'The password or email address is incorrect.',
        );
      } else if (e.code == 'wrong-password') {
        throw CustomException(
          message: 'The password or email address is incorrect.',
        );
      } else if (e.code == 'invalid-credential') {
        throw CustomException(
          message: 'The password or email address is incorrect.',
        );
      } else if (e.code == 'network-request-failed') {
        throw CustomException(
          message: 'Make sure you have an internet connection.',
        );
      } else {
        throw CustomException(
          message: 'Something went wrong. Please try again.',
        );
      }
    } catch (e) {
      log(
        "Exception in FirebaseAuthService.signInWithEmailAndPassword: ${e.toString()}",
      );

      throw CustomException(message: 'Something went wrong. Please try again.');
    }
  }

  bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<User> signInWithGoogle() async {
    try {
      print('🔹 Starting the Google login process...');
      // 1️⃣ فتح نافذة تسجيل الدخول بجوجل
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print('✅ after GoogleSignIn().signIn()');
      if (googleUser == null) {
        print('⚠️ The user cancelled the login process.');
        throw CustomException(message: 'The user has cancelled their login.');
      }

      // 2️⃣ الحصول على بيانات التوثيق من Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print('✅ Obtained googleAuth: ${googleAuth.idToken != null}');
      // 3️⃣ إنشاء credential من Google
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print('✅ credential created successfully.');
      // 4️⃣ تسجيل الدخول إلى Firebase باستخدام credential
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      print('✅ Firebase login successful.');
      // 5️⃣ طباعة بيانات المستخدم
      print('👤 Username: ${userCredential.user?.displayName}');

      print('📧 Email: ${userCredential.user?.email}');

      print('🆔 UID: ${userCredential.user?.uid}');

      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      print('❌ FirebaseAuthException: ${e.code}');
      throw CustomException(message: 'حدث خطأ في Firebase: ${e.code}');
    } catch (e) {
      print('❌ Unexpected error in signInWithGoogle: $e');
      throw CustomException(
        message: 'Something went wrong while signing in to Google.',
      );
    }
  }
}
