// lib/features/signup/data/repositories/signup_repository_impl.dart
import 'package:structural_health_predictor/Features/signup/Domain/Entities/signup_entities.dart';
import 'package:structural_health_predictor/Features/signup/Domain/Repositories_abstract/signup_repository_abstract.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SignupRepositoryImpl implements SignupRepositoryAbstract {
  final SupabaseClient
  supabaseClient; 

  SignupRepositoryImpl({required this.supabaseClient}); 

  @override
  Future<SignupEntities> signup({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // Password validation
    if (password != confirmPassword) {
      throw Exception('Passwords do not match');
    }

    // Signup with Supabase
    final response = await supabaseClient.auth.signUp(
      email: email.trim(),
      password: password,
      data: {'username': username.trim(), 'email': email.trim()},
    );

    if (response.user == null) {
      throw Exception('Signup failed');
    }

    return SignupEntities(
      username: username,
      email: email,
      password: '',
      confirmPassword: '',
    );
  }
}
