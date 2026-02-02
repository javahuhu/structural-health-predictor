import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;

import 'package:structural_health_predictor/Features/LogIn/Presentation/Bloc/log_in_bloc.dart';

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({super.key});

  @override
  State<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

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

    // Create 8 bubbles with random properties
    for (int i = 0; i < 8; i++) {
      final controller = AnimationController(
        duration: Duration(seconds: 10 + random.nextInt(10)),
        vsync: this,
      );

      final animation = Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.linear));

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
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Detect if keyboard is visible
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = bottomInsets > 100.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside text fields
          FocusScope.of(context).unfocus();
        },
        child: SizedBox(
          width: 1.sw,
          height: 1.sh,
          child: Stack(
            children: [
              // Animated Bubbles Background
              ...List.generate(_bubbles.length, (index) {
                return AnimatedBuilder(
                  animation: _bubbleAnimations[index],
                  builder: (context, child) {
                    final bubble = _bubbles[index];
                    final progress = _bubbleAnimations[index].value;

                    // Calculate position
                    final xPos =
                        bubble.startX + (bubble.endX - bubble.startX) * progress;
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

              // Login Form
              SafeArea(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 15.h,
                    ),
                    child: BlocConsumer<LoginBloc, LoginState>(
                      listener: (context, state) {
                        if (state is LoginSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Login successful!'),
                              backgroundColor: const Color(0xFF0F3460),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                          );

                          _usernameController.clear();
                          _passwordController.clear();

                          
                          context.go('/dashboard');
                        } else if (state is LoginFailure) {
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
                        }
                      },
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
                          // Conditional scroll based on keyboard visibility
                          child: isKeyboardVisible
                              ? SingleChildScrollView(
                                  physics: const ClampingScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 30.w,
                                    vertical: 30.h,
                                  ),
                                  child: _buildFormContent(state),
                                )
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 30.w,
                                    vertical: 30.h,
                                  ),
                                  child: _buildFormContent(state),
                                ),
                        );
                      },
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

  // Extracted form content to avoid duplication
  Widget _buildFormContent(LoginState state) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo/Icon
          Container(
            width: 60.r,
            height: 60.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A1A2E),
                  Color(0xFF0F3460),
                ],
              ),
            ),
            child: Icon(
              Icons.lock_person_outlined,
              size: 35.r,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20.h),

          // Title
          Text(
            'Welcome Back',
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
            'Login to continue',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
          SizedBox(height: 30.h),

          // Username Field
          _buildTextField(
            controller: _usernameController,
            label: 'Username',
            hint: 'Enter your username',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),

          // Password Field
          _buildTextField(
            controller: _passwordController,
            label: 'Password',
            hint: 'Enter your password',
            icon: Icons.lock_outline,
            isPassword: true,
            isPasswordVisible: _isPasswordVisible,
            onTogglePassword: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          SizedBox(height: 10.h),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                // Navigate to forgot password page
                // Navigator.pushNamed(context, '/forgot-password');
              },
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  color: const Color(0xFF0F3460),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 28.h),

          // Login Button
          _buildLoginButton(state),

          SizedBox(height: 24.h),

          // Divider with "OR"
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: const Color(0xFFE5E7EB),
                  thickness: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                ),
                child: Text(
                  'OR',
                  style: TextStyle(
                    color: const Color(0xFF6B7280),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: const Color(0xFFE5E7EB),
                  thickness: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Signup Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: TextStyle(
                  color: const Color(0xFF6B7280),
                  fontSize: 13.sp,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.go('/signup');
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: const Color(0xFF0F3460),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
    TextInputType? keyboardType,
    String? Function(String?)? validator,
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
              prefixIcon: Icon(
                icon,
                color: const Color(0xFF6B7280),
                size: 20.r,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: const Color(0xFF6B7280),
                        size: 20.r,
                      ),
                      onPressed: onTogglePassword,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 14.h,
              ),
              errorStyle: TextStyle(fontSize: 11.sp, height: 1.3),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(LoginState state) {
    final isLoading = state is LoginLoading;

    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A2E), Color(0xFF0F3460)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F3460).withOpacity(0.3),
            blurRadius: 20.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.zero,
        ),
        child: isLoading
            ? SizedBox(
                height: 22.r,
                width: 22.r,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(
            LoginSubmitted(
              username: _usernameController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }
}

// Bubble model class
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