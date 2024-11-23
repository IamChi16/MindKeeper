// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      final googleAuth = await googleUser?.authentication;

      final cred = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await _auth.signInWithCredential(cred);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<UserCredential?> signupWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      final googleAuth = await googleUser?.authentication;

      final cred = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await _auth.signInWithCredential(cred);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> sendEmailVerificationLink() async {
    try {
      final user = _auth.currentUser;
      await user?.sendEmailVerification();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> sendPasswordResetLink(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> createUser({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    String message = 'Some error occurred';
    try {
      if (password != confirmPassword) {
        return 'Passwords do not match';
      }
      if (email.isEmpty || password.isEmpty) {
        return 'Please fill all fields';
      }

      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(cred.user!.uid).set({
        'email': email,
        'uid': cred.user!.uid,
      });

      await cred.user!.sendEmailVerification();
      message = 'Success';
    } on FirebaseAuthException catch (e) {
      message = exceptionHandler(e.code);
    }
    return message;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'Your email or password is incorrect';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = 'Success';
      } else {
        res = 'Please fill all the fields';
      }
    } on FirebaseAuthException catch (e) {
      exceptionHandler(e.code);
    }
    return res;
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<User?> get user => _auth.authStateChanges();

  //change username
  Future<void> changeUsername(String name) async {
    try {
      final user = _auth.currentUser;
      await user?.updateDisplayName(name);
    } catch (e) {
      print(e.toString());
    }
  }

  //change ava
  Future<void> saveImageUrl(String userId, String imageId) async{
    await _firestore.collection('users').doc(userId).update({
      'photoId': imageId,
    });
  }
}

exceptionHandler(String code) {
  switch (code) {
    case 'email-already-in-use':
      return 'Email already in use';
    case 'invalid-email':
      return 'Invalid email';
    case 'weak-password':
      return 'Your password must be at least 8 characters';
    case 'user-not-found':
      return 'User not found';
    case 'wrong-password':
      return 'Wrong password';
    default:
      return 'An error occurred';
  }
}
