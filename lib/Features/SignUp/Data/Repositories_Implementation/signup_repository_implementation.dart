// lib/features/signup/data/repositories/signup_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:structural_health_predictor/Features/signup/Domain/Entities/signup_entities.dart';
import 'package:structural_health_predictor/Features/signup/Domain/Repositories_abstract/signup_repository_abstract.dart';


class SignupRepositoryImpl implements SignupRepositoryAbstract {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  SignupRepositoryImpl({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  @override
  Future<SignupEntities> signup({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      throw Exception('Passwords do not match');
    }

    UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    User? user = userCredential.user;

    if (user == null) {
      throw Exception('Signup failed');
    }

    await firebaseFirestore.collection('users').doc(user.uid).set({
      'username': username,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return SignupEntities(
      username: username,
      email: email,
      password: '',
      confirmPassword: '',
    );
  }
}
