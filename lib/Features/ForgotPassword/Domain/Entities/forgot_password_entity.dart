class ForgotPasswordEntity {
  final bool success;
  final String message;
  final String step; 

  ForgotPasswordEntity({
    required this.success,
    required this.message,
    required this.step,
  });

  ForgotPasswordEntity copyWith({
    bool? success,
    String? message,
    String? step,
  }) {
    return ForgotPasswordEntity(
      success: success ?? this.success,
      message: message ?? this.message,
      step: step ?? this.step,
    );
  }
}

