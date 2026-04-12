import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:math';
import 'package:structural_health_predictor/Features/ForgotPassword/Domain/Entities/forgot_password_entity.dart';
import 'package:structural_health_predictor/Features/ForgotPassword/Domain/Repositories_abstract/forgot_password_repository_abstract.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepositoryAbstract {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  ForgotPasswordRepositoryImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  String _generateVerificationCode() {
    return (100000 + Random().nextInt(900000)).toString();
  }

  @override
  Future<ForgotPasswordEntity> checkEmailExists({
    required String email,
  }) async {
    try {
      // Check if user exists in Firestore
      final querySnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: email.toLowerCase())
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('No account found with this email address');
      }

      return ForgotPasswordEntity(
        success: true,
        message: 'Email verified. Check your app for verification code.',
        step: 'email_check',
      );
    } catch (e) {
      throw Exception('Error checking email: ${e.toString()}');
    }
  }

  @override
  Future<ForgotPasswordEntity> sendVerificationCode({
    required String email,
  }) async {
    try {
      final code = _generateVerificationCode();

      await firestore.collection('verification_codes').doc(email).set({
        'code': code,
        'createdAt': DateTime.now(),
        'expiresAt': DateTime.now().add(const Duration(minutes: 15)),
        'attempts': 0,
      });

      // Send verification code via email using Cloud Function
      try {
        final HttpsCallable callable =
            FirebaseFunctions.instance.httpsCallable('sendVerificationEmail');

        await callable.call({
          'email': email,
          'code': code,
          'expirationMinutes': 15,
        });

        print('✅ Verification code sent to $email: $code (Valid for 15 minutes)');
      } catch (emailError) {
        print('⚠️ Email sending failed: ${emailError.toString()}');
        print('🔐 Verification code (development): $code');
      }

      return ForgotPasswordEntity(
        success: true,
        message: 'Your verification code is:\n\n$code\n\nValid for 15 minutes',
        step: 'code_sent',
      );
    } catch (e) {
      throw Exception('Failed to send verification code: ${e.toString()}');
    }
  }

  @override
  Future<ForgotPasswordEntity> verifyCode({
    required String email,
    required String code,
  }) async {
    try {
      final doc = await firestore.collection('verification_codes').doc(email).get();

      if (!doc.exists) {
        throw Exception('No verification code found. Please request a new one.');
      }

      final data = doc.data() as Map<String, dynamic>;
      final storedCode = data['code'] as String;
      final expiresAt = (data['expiresAt'] as Timestamp).toDate();
      int attempts = data['attempts'] as int? ?? 0;

      if (DateTime.now().isAfter(expiresAt)) {
        throw Exception('Verification code expired. Please request a new one.');
      }

      if (attempts >= 3) {
        throw Exception('Too many failed attempts. Please request a new code.');
      }

      if (storedCode != code) {
        await firestore.collection('verification_codes').doc(email).update({
          'attempts': attempts + 1,
        });
        throw Exception('Invalid verification code. Please try again.');
      }

      return ForgotPasswordEntity(
        success: true,
        message: 'Code verified successfully',
        step: 'code_verified',
      );
    } catch (e) {
      throw Exception('Verification failed: ${e.toString()}');
    }
  }

  @override
  Future<ForgotPasswordEntity> updatePassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);

      // Step 2: Clean up verification code
      await firestore.collection('verification_codes').doc(email).delete().catchError((_) {
        return null;
      });

      print('✅ Password reset email sent to $email');

      return ForgotPasswordEntity(
        success: true,
        message: 'Password reset email sent!\n\nCheck your inbox for the reset link.',
        step: 'password_reset',
      );
    } catch (e) {
      throw Exception('Failed to send password reset email: ${e.toString()}');
    }
  }
}


