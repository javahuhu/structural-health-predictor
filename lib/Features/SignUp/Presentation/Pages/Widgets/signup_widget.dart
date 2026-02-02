import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:structural_health_predictor/features/signup/presentation/bloc/signup_bloc.dart';
import 'dart:math' as math;

class SignupPageWidget extends StatefulWidget {
  const SignupPageWidget({super.key});

  @override
  State<SignupPageWidget> createState() => _SignupPageWidgetState();
}

class _SignupPageWidgetState extends State<SignupPageWidget>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Add scroll controller
  final ScrollController _scrollController = ScrollController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  late List<AnimationController> _bubbleControllers;
  late List<Animation<double>> _bubbleAnimations;
  final List<Bubble> _bubbles = [];

  @override
  void initState() {
    super.initState();
    _initializeBubbles();
  }

  @override
  void dispose() {
    for (var controller in _bubbleControllers) {
      controller.dispose();
    }
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _scrollController.dispose(); // Dispose scroll controller
    super.dispose();
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
  Widget build(BuildContext context) {
    
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = bottomInsets > 100.0; 

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
         
          FocusScope.of(context).unfocus();
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
                          color: bubble.color.withValues(alpha: 0.05),
                          border: Border.all(
                            color: bubble.color.withValues(alpha: 0.1),
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
                    child: BlocConsumer<SignupBloc, SignupState>(
                      listener: (context, state) {
                        if (state is SignupSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Signup successful! Please check your email to verify your account.',
                              ),
                              backgroundColor: const Color(0xFF0F3460),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                          );

                          _usernameController.clear();
                          _emailController.clear();
                          _passwordController.clear();
                          _confirmPasswordController.clear();
                        } else if (state is SignupFailure) {
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
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 30.r,
                                offset: Offset(0, 10.h),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          // Wrap with SingleChildScrollView only when keyboard is visible
                          child: isKeyboardVisible
                              ? SingleChildScrollView(
                                  controller: _scrollController,
                                  physics: const ClampingScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 30.w,
                                    vertical: 20.h,
                                  ),
                                  child: _buildFormContent(state),
                                )
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 30.w,
                                    vertical: 20.h,
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

  // Extract the form content to a separate method to avoid duplication
  Widget _buildFormContent(SignupState state) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 50.r,
            height: 50.r,
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
              Icons.account_circle_outlined,
              size: 30.r,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 15.h),

          Text(
            'Create Account',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F0F0F),
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            'Sign up to get started',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
          SizedBox(height: 20.h),

          _buildTextField(
            controller: _usernameController,
            label: 'Username',
            hint: 'Enter your username',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a username';
              }
              if (value.length < 3) {
                return 'Username must be at least 3 characters';
              }
              return null;
            },
          ),
          SizedBox(height: 10.h),

          _buildTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'Enter your email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: 10.h),

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
                return 'Please enter a password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          SizedBox(height: 10.h),

          _buildTextField(
            controller: _confirmPasswordController,
            label: 'Confirm Password',
            hint: 'Re-enter your password',
            icon: Icons.lock_outline,
            isPassword: true,
            isPasswordVisible: _isConfirmPasswordVisible,
            onTogglePassword: () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),

          _buildSignupButton(state),

          SizedBox(height: 15.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: TextStyle(
                  color: const Color(0xFF6B7280),
                  fontSize: 12.sp,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.go('/login');
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: const Color(0xFF0F3460),
                    fontSize: 12.sp,
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
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6.h),
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
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: const Color(0xFF9CA3AF),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                icon,
                color: const Color(0xFF6B7280),
                size: 18.r,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: const Color(0xFF6B7280),
                        size: 18.r,
                      ),
                      onPressed: onTogglePassword,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 12.h,
              ),
              errorStyle: TextStyle(fontSize: 10.sp, height: 1.3),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget _buildSignupButton(SignupState state) {
    final isLoading = state is SignupLoading;

    return Container(
      height: 42.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A2E), Color(0xFF0F3460)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F3460).withValues(alpha: 0.3),
            blurRadius: 20.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : _handleSignup,
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
                height: 20.r,
                width: 20.r,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      context.read<SignupBloc>().add(
            SignupSubmitted(
              username: _usernameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
              confirmPassword: _confirmPasswordController.text,
            ),
          );
    }
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