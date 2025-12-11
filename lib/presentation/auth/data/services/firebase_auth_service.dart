import 'dart:developer';

import 'package:alwadi_food/core/errors/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // get current user
  User? get currentUser => _auth.currentUser;
  // signIn whith email and password
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      log(
        "Exception in FirebaseAuthService.signInWithEmailAndPassword: ${e.toString()} and code is ${e.code}",
      );
      if (e.code == 'user-not-found') {
        throw CustomException(
          message: ' The password or email address is incorrect.',
        );
      } else if (e.code == 'wrong-password') {
        throw CustomException(
          message: ' The password or email address is incorrect.',
        );
      } else if (e.code == 'invalid-credential') {
        throw CustomException(
          message: ' The password or email address is incorrect.',
        );
      } else if (e.code == 'network-request-failed') {
        throw CustomException(
          message: 'Make sure you are connected to the internet.',
        );
      } else {
        throw CustomException(
          message: ' Something went wrong. Please try again.',
        );
      }
    } catch (e) {
      log(
        "Exception in FirebaseAuthService.signInWithEmailAndPassword: ${e.toString()}",
      );

      throw CustomException(message: 'Something went wrong. Please try again.');
    }
  }
  // signup whith email and password

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      log(
        "Exception in FirebaseAuthService.createUserWithEmailAndPassword: ${e.toString()} and code is ${e.code}",
      );
      if (e.code == 'weak-password') {
        throw CustomException(message: 'The password is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw CustomException(
          message: 'I have already registered. Please log in.',
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
        "Exception in FirebaseAuthService.createUserWithEmailAndPassword: ${e.toString()}",
      );

      throw CustomException(message: 'Something went wrong. Please try again.');
    }
  }
// signOut
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint("FirebaseAuthService.signOut error: $e");
      rethrow;
    }
  }
// authStateChanges
  Stream<User?> authStateChanges() => _auth.authStateChanges();
}
