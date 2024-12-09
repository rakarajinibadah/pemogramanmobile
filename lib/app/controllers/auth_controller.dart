import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static FirebaseAuth auth = FirebaseAuth.instance;

  // Make `user` nullable
  static User? get user => auth.currentUser;

  // Make `userEmail` nullable and provide a null-safe getter
  static String? get userEmail => user?.email;

  RxBool isLoading = false.obs;

  // Handle email verification safely
  static bool get isEmailVerified => user?.emailVerified ?? false;

  // Login method
  void login(String email, String password) async {
    isLoading.value = true;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.user!.emailVerified) {
        Get.snackbar(
          'Success',
          'Login success',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        DocumentSnapshot snapshot = await firestore
            .collection('users')
            .doc(userCredential.user!.email)
            .get();
        final data = snapshot.data() as Map<String, dynamic>;

        Get.offAllNamed('/layout', arguments: data);
      } else {
        Get.defaultDialog(
          title: 'Verification Email',
          middleText:
              'Anda perlu melakukan verifikasi email untuk melanjutkan.',
          textConfirm: 'OK',
          confirmTextColor: Colors.white,
          onConfirm: () {
            Get.back();
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('Error', 'User not found',
            backgroundColor: Colors.red, colorText: Colors.white);
      } else if (e.code == 'invalid-credential') {
        Get.snackbar('Error', 'Invalid credential',
            backgroundColor: Colors.red, colorText: Colors.white);
      } else if (e.code == 'invalid-email') {
        Get.snackbar('Error', 'Invalid credential',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
      print('firebase auth exception: $e');
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print('error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Register method
  void register(String email, String password, String name) async {
    isLoading.value = true;
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.sendEmailVerification();
      Get.snackbar(
        'Success',
        'A verification email has been sent',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      while (!FirebaseAuth.instance.currentUser!.emailVerified) {
        await Future.delayed(
          Duration(seconds: 5),
          () => FirebaseAuth.instance.currentUser!.reload(),
        );
      }

      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      final checkUser = await users.doc(credential.user!.email).get();
      if (checkUser.data() == null) {
        users.doc(credential.user!.email).set({
          "id": credential.user!.uid,
          "name": name,
          "email": credential.user!.email,
          "timestamp": Timestamp.now(),
        }, SetOptions(merge: true));
      }

      Get.snackbar(
        'Success',
        'Register success',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAllNamed('/layout');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar('Error', 'Password too weak',
            backgroundColor: Colors.red, colorText: Colors.white);
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar('Error', 'Email already in use',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Logout method
  void logout() async {
    await auth.signOut();
    Get.snackbar('Success', 'Logout success',
        backgroundColor: Colors.green, colorText: Colors.white);
    Get.offAllNamed('/onboarding');
  }

  // Send password reset email method
  void sendPasswordResetEmail(String email) async {
    isLoading.value = true;
    try {
      await auth.sendPasswordResetEmail(email: email);
      Get.snackbar('Success', 'Password reset email sent',
          backgroundColor: Colors.green, colorText: Colors.white);
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Auth stream for listening to auth state changes
  Stream<User?> get streamAuthStatus => auth.authStateChanges();
}
