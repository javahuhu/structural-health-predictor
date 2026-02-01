class LogInEntities {
  final String username;
  final String email;
  final String password;

  LogInEntities({
    required this.username,
    required this.email,
    required this.password,
  });

  LogInEntities copyWith({String? username, String? email, String? password}) {
    return LogInEntities(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
