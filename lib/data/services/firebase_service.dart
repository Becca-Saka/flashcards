import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcards/model/exceptions/auth_exception.dart';
import 'package:flashcards/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class IFirebaseService {
  Future<UserModel> getCurrentUserData();
  Future<UserModel?> signIn(String email, String password);
  Future<bool> createAccount(
    String email,
    String password,
    String firstName,
    String lastName,
  );
  Future<UserModel?> logInWithGoogleUser();
  Future<void> signOut();
}

class FirebaseService extends IFirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _firestore =
      FirebaseFirestore.instance.collection('users');

  final _googleSignIn = GoogleSignIn(scopes: ['email']);

  User? get currentUser => _auth.currentUser;

  Future<bool> _saveUserDetails(UserModel userModel) async {
    try {
      await _firestore.doc(userModel.uid).set(userModel.toMap());

      return true;
    } on FirebaseAuthException catch (e) {
      final message = AuthExceptionHandler.handleFirebaseAuthException(e);
      throw AuthException(message);
    } on Exception catch (e, s) {
      debugPrint('$e\n$s');
      rethrow;
    }
  }

  @override
  Future<UserModel> getCurrentUserData() async {
    try {
      final response = await _firestore.doc(_auth.currentUser!.uid).get();
      if (response.data() != null) {
        return UserModel.fromMap(response.data()! as Map<String, dynamic>);
      }
      throw AuthException('User not found');
    } on FirebaseAuthException catch (e) {
      final message = AuthExceptionHandler.handleFirebaseAuthException(e);
      throw AuthException(message);
    } on Exception catch (e, s) {
      debugPrint('$e\n$s');
      rethrow;
    }
  }

  @override
  Future<UserModel?> logInWithGoogleUser() async {
    try {
      await signOut();
      final googleAccount = await _googleSignIn.signIn();
      if (googleAccount != null) {
        final auth = await googleAccount.authentication;
        final googleAuthAccessToken = auth.accessToken;
        final authCredential = GoogleAuthProvider.credential(
            accessToken: googleAuthAccessToken, idToken: auth.idToken);
        final userCredienditial =
            await FirebaseAuth.instance.signInWithCredential(authCredential);
        final name = userCredienditial.user!.displayName;
        final firstName = name!.split(' ')[0];
        final lastName = name.split(' ')[1];
        UserModel user = UserModel(
          uid: userCredienditial.user!.uid,
          firstName: firstName,
          lastName: lastName,
          email: userCredienditial.user!.email,
          imageUrl: userCredienditial.user!.photoURL,
        );
        await _saveUserDetails(user);
        return user;
      }
      throw AuthException('Error signing in with Google');
    } on FirebaseAuthException catch (e) {
      final message = AuthExceptionHandler.handleFirebaseAuthException(e);
      debugPrint('$message');
      throw AuthException(message);
    } on Exception catch (e, s) {
      debugPrint('$e\n$s');
      rethrow;
    }
  }

  @override
  Future<bool> createAccount(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      final credientials = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      UserModel user = UserModel(
        uid: credientials.user!.uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
      );
      await _saveUserDetails(user);
      await signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      final message = AuthExceptionHandler.handleFirebaseAuthException(e);
      debugPrint('$message');
      throw AuthException(message);
    } on Exception catch (e, s) {
      debugPrint('$e\n$s');
      rethrow;
    }
  }

  @override
  Future<UserModel?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return await getCurrentUserData();
    } on FirebaseAuthException catch (e) {
      final message = AuthExceptionHandler.handleFirebaseAuthException(e);
      debugPrint('$message');
      throw AuthException(message);
    } on Exception catch (e, s) {
      debugPrint('$e\n$s');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
