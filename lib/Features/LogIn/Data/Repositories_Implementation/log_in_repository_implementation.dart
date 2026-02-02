import 'package:structural_health_predictor/Features/LogIn/Domain/Entities/log_in_entities.dart';
import 'package:structural_health_predictor/Features/LogIn/Domain/Repositories_abstract/log_in_repository_abstract.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginRepositoryImpl implements LogInRepositoryAbstract {
  final SupabaseClient supabaseClient;

LoginRepositoryImpl({required this.supabaseClient});

  @override
  Future<LogInEntities> login({
    required String username,
    required String password,
  }) async {
    String email = username;

    if (!username.contains('@')) {
      final res = await supabaseClient
          .from('profiles')
          .select('email')
          .eq('username', username)
          .single();

      email = res['email'];
    }

    final response = await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Invalid credentials');
    }

    return LogInEntities(username: username, email: email, password: '');
  }
}
