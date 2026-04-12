import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;

import 'package:structural_health_predictor/Features/ForgotPassword/Presentation/Bloc/forgot_password_bloc.dart';

class ForgotPasswordPageWidget extends StatefulWidget {
  const ForgotPasswordPageWidget({super.key});

  @override
  State<ForgotPasswordPageWidget> createState() =>
      _ForgotPasswordPageWidgetState();
}

class _ForgotPasswordPageWidgetState extends State<ForgotPasswordPageWidget>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();

  late List<AnimationController> _bubbleControllers;
  late List<Animation<double>> _bubbleAnimations;
  final List<Bubble> _bubbles = [];

  @override
  void initState() {
    super.initState();
    _initializeBubbles();
  }

  void _initializeBubbles() {
    final random = math.Random();
    _bubbleControllers = [];
    _bubbleAnimations = [];

    for (int i = 0; i < 8; i++) {
      final controller = AnimationController(
        duration: Duration(seconds: 10 + random.nextInt(10)),
        vsync: this,
      );

      final animation = Tween<double>(begin: 0, end: 1)
          .animate(CurvedAnimation(parent: controller, curve: Curves.linear));

      _bubbleControllers.add(controller);
      _bubbleAnimations.add(animation);

      _bubbles.add(
        Bubble(
          size: 40.w + random.nextDouble() * 120.w,
          startX: random.nextDouble(),
          endX: random.nextDouble(),
          startY: 1.0 + random.nextDouble() * 0.2,
          color: [
            const Color(0xFF0F0F0F),
            const Color(0xFF1A1A2E),
            const Color(0xFF16213E),
            const Color(0xFF0F3460),
          ][random.nextInt(4)],
        ),
      );

      controller.repeat();
    }
  }

  @override
  void dispose() {
    for (var controller in _bubbleControllers) {
      controller.dispose();
    }
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _emailController.clear();
    _codeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = bottomInsets > 100.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: PopScope(
        canPop: true,
        onPopInvoked: (_) {
          _resetForm();
          context.read<ForgotPasswordBloc>().add(const ResetForgotPasswordForm());
        },
        child: SizedBox(
          width: 1.sw,
          height: 1.sh,
          child: Stack(
            children: [
              ...List.generate(_bubbles.length, (index) {
                return AnimatedBuilder(
                  animation: _bubbleAnimations[index],
                  builder: (context, child) {
                    final bubble = _bubbles[index];
                    final progress = _bubbleAnimations[index].value;
                    final xPos = bubble.startX +
                        (bubble.endX - bubble.startX) * progress;
                    final yPos = bubble.startY - progress * 1.2;

                    return Positioned(
                      left: xPos * 1.sw - bubble.size / 2,
                      top: yPos * 1.sh,
                      child: Container(
                        width: bubble.size,
                        height: bubble.size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: bubble.color.withOpacity(0.05),
                          border: Border.all(
                            color: bubble.color.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
              SafeArea(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 15.h,
                    ),
                    child: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
                      listener: (context, state) {
                        if (state is EmailCheckFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.error),
                              backgroundColor: Colors.red.shade700,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                          );
                        } else if (state is CodeVerificationFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.error),
                              backgroundColor: Colors.red.shade700,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                          );
                        } else if (state is EmailCheckSuccess) {
                          _emailController.clear();
                          Future.microtask(() {
                            final lines = state.message.split('\n');
                            final code = lines.length > 2 ? lines[2] : '000000';

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (dialogContext) => AlertDialog(
                                title: Text(
                                  'Verification Code',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0F3460),
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Your verification code:',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: const Color(0xFF6B7280),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Container(
                                      padding: EdgeInsets.all(16.w),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3F4F6),
                                        borderRadius: BorderRadius.circular(12.r),
                                        border: Border.all(
                                          color: const Color(0xFF0F3460),
                                          width: 2,
                                        ),
                                      ),
                                      child: Text(
                                        code,
                                        style: TextStyle(
                                          fontSize: 32.sp,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF0F3460),
                                          letterSpacing: 4,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    Text(
                                      'Valid for 15 minutes',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF0F3460),
                                        padding: EdgeInsets.symmetric(vertical: 12.h),
                                      ),
                                      onPressed: () => Navigator.pop(dialogContext),
                                      child: Text(
                                        'Got it',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                        }
                      },
                      child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                        builder: (context, state) {
                          return Container(
                            width: 450.w,
                            constraints: BoxConstraints(
                              maxHeight: isKeyboardVisible ? 0.8.sh : 0.9.sh,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.r),
                              color: const Color.fromARGB(171, 255, 255, 255),
                              border: Border.all(
                                color: const Color.fromARGB(43, 0, 0, 0),
                                width: 0.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 30.r,
                                  offset: Offset(0, 10.h),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: isKeyboardVisible
                                ? SingleChildScrollView(
                                    physics: const ClampingScrollPhysics(),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 30.w,
                                      vertical: 30.h,
                                    ),
                                    child: _buildContent(state),
                                  )
                                : Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 30.w,
                                      vertical: 30.h,
                                    ),
                                    child: _buildContent(state),
                                  ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ForgotPasswordState state) {
    if (state is ForgotPasswordInitial ||
        state is EmailCheckLoading ||
        state is EmailCheckFailure) {
      return _buildEmailForm(state);
    } else if (state is EmailCheckSuccess ||
        state is CodeVerificationLoading ||
        state is CodeVerificationFailure) {
      return _buildCodeVerificationForm(state);
    } else if (state is PasswordResetSuccess) {
      return _buildSuccessForm(state);
    }

    return _buildEmailForm(state);
  }

  Widget _buildEmailForm(ForgotPasswordState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: 60.r,
          height: 60.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1A2E), Color(0xFF0F3460)],
            ),
          ),
          child: Icon(Icons.email_outlined, size: 35.r, color: Colors.white),
        ),
        SizedBox(height: 20.h),
        Text(
          'Reset Password',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F0F0F),
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Enter your email address',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
        ),
        SizedBox(height: 30.h),
        _buildTextField(
          controller: _emailController,
          label: 'Email',
          hint: 'Enter your email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 28.h),
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F3460),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: state is EmailCheckLoading
                ? null
                : () {
                    if (_emailController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Please enter your email'),
                        backgroundColor: Colors.red.shade700,
                      ));
                      return;
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(_emailController.text)) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Please enter a valid email'),
                        backgroundColor: Colors.red.shade700,
                      ));
                      return;
                    }
                    context.read<ForgotPasswordBloc>().add(
                          CheckEmailSubmitted(
                            email: _emailController.text.trim(),
                          ),
                        );
                  },
            child: state is EmailCheckLoading
                ? SizedBox(
                    height: 20.h,
                    width: 20.h,
                    child: const CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Back to Login',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF0F3460),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCodeVerificationForm(ForgotPasswordState state) {
    final email = state is EmailCheckSuccess ? state.email : '';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: 60.r,
          height: 60.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1A2E), Color(0xFF0F3460)],
            ),
          ),
          child: Icon(Icons.security_outlined, size: 35.r, color: Colors.white),
        ),
        SizedBox(height: 20.h),
        Text(
          'Verify Code',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F0F0F),
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Enter the verification code shown in the dialog',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
        ),
        SizedBox(height: 30.h),
        _buildTextField(
          controller: _codeController,
          label: 'Verification Code',
          hint: 'Enter 6-digit code',
          icon: Icons.numbers_outlined,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 28.h),
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F3460),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: state is CodeVerificationLoading
                ? null
                : () {
                    if (_codeController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Please enter the verification code'),
                        backgroundColor: Colors.red.shade700,
                      ));
                      return;
                    }
                    if (_codeController.text.length != 6) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Code must be 6 digits'),
                        backgroundColor: Colors.red.shade700,
                      ));
                      return;
                    }
                    context.read<ForgotPasswordBloc>().add(
                          VerifyCodeSubmitted(
                            email: email,
                            code: _codeController.text,
                          ),
                        );
                  },
            child: state is CodeVerificationLoading
                ? SizedBox(
                    height: 20.h,
                    width: 20.h,
                    child: const CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Verify',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: TextButton(
            onPressed: () {
              _resetForm();
              context
                  .read<ForgotPasswordBloc>()
                  .add(const ResetForgotPasswordForm());
            },
            child: Text(
              'Back',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF0F3460),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessForm(PasswordResetSuccess state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: 60.r,
          height: 60.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
            ),
          ),
          child: Icon(
            Icons.mark_email_read_outlined,
            size: 35.r,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          'Check Your Email!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F0F0F),
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          state.message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFF86EFAC)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline,
                  color: const Color(0xFF16A34A), size: 16.r),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'After clicking the link in your email, come back and log in with your new password.',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF16A34A),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30.h),
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F3460),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: () {
              _resetForm();
              context.go('/login');
            },
            child: Text(
              'Back to Login',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF0F0F0F),
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
            color: const Color(0xFFFAFAFA),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword && !isPasswordVisible,
            keyboardType: keyboardType,
            style: TextStyle(
              color: const Color(0xFF0F0F0F),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: const Color(0xFF9CA3AF),
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(icon, color: const Color(0xFF6B7280), size: 20.r),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 12.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Bubble {
  final double size;
  final double startX;
  final double endX;
  final double startY;
  final Color color;

  Bubble({
    required this.size,
    required this.startX,
    required this.endX,
    required this.startY,
    required this.color,
  });
}