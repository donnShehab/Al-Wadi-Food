import 'dart:developer';

import 'package:alwadi_food/core/errors/exceptions.dart';
import 'package:alwadi_food/core/errors/failures.dart';
import 'package:alwadi_food/feature/auth/domain/entites/user_entity.dart';
import 'package:dart_either/dart_either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
          message:'The password or email address is incorrect.',
        );
      } else if (e.code == 'network-request-failed') {
        throw CustomException(message: 'Make sure you have an internet connection.',
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

      throw CustomException(
        message: 'Something went wrong. Please try again.',
      );
    }
  }

   bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }
}
