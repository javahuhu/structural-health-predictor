import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:structural_health_predictor/Features/LogIn/Domain/Entities/log_in_entities.dart';
import 'package:structural_health_predictor/Features/LogIn/Domain/Repositories_abstract/log_in_repository_abstract.dart';

class LoginRepositoryImpl implements LogInRepositoryAbstract {
  final FirebaseAuth firebaseAuth;

  LoginRepositoryImpl({required this.firebaseAuth});

  @override
  Future<LogInEntities> login({
    required String username,
    required String password,
  }) async {
    String email = username;

    if (!username.contains('@')) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('User not found');
      }

      email = querySnapshot.docs.first['email'];
    }

    final response = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Invalid credentials');
    }

    return LogInEntities(username: username, email: email, password: '');
  }
}
