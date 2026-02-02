import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _fadeController.forward();
    navigateToLogIn();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void navigateToLogIn() async {
    await Future.delayed(const Duration(seconds: 5));
    if (mounted) {
      context.go('/getstarted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F0F0F), // Almost black
              Color(0xFF1A1A2E), // Dark navy
              Color(0xFF16213E), // Deep blue-grey
              Color(0xFF0F3460), // Dark blue
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 40.h,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // White card container with subtle glow
                      Container(
                        padding: EdgeInsets.all(32.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF00D9FF,
                              ).withAlpha(38), // 0.15 * 255 = 38
                              blurRadius: 40.r,
                              spreadRadius: 5.r,
                              offset: Offset(0, 10.h),
                            ),
                            BoxShadow(
                              color: const Color(
                                0xFF7B2CBF,
                              ).withAlpha(26), // 0.1 * 255 = 26
                              blurRadius: 30.r,
                              spreadRadius: -5.r,
                              offset: Offset(0, -5.h),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Lottie.asset(
                              'assets/lottie/splashlottie.json',
                              width: 300.r,
                              height: 300.r,
                              repeat: true,
                              fit: BoxFit.contain,
                            ),

                            // App title with gradient
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFF0F3460), Color(0xFF00D9FF)],
                              ).createShader(bounds),
                              child: Text(
                                'Structural Health\nPredictor',
                                style: GoogleFonts.poppins(
                                  fontSize: 23.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.2,
                                  letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            SizedBox(height: 16.h),

                            
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Text(
                                'Advanced crack detection and structural integrity assessment using deep learning',
                                style: GoogleFonts.inter(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            SizedBox(height: 24.h),

                            // Loading indicator
                            SizedBox(
                              width: 150.w,
                              child: LinearProgressIndicator(
                                backgroundColor: const Color(
                                  0xFF00D9FF,
                                ).withAlpha(26),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF00D9FF),
                                ),
                                minHeight: 4.h,
                                // borderRadius: BorderRadius.circular(2.r), // optional
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 40.h),

                      // Bottom tagline with glassmorphic effect
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(20), // ~0.08 opacity
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: Colors.white.withAlpha(38), // ~0.15 opacity
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00D9FF).withAlpha(26),
                              blurRadius: 15.r,
                              spreadRadius: 1.r,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.security,
                              size: 18.sp,
                              color: const Color(0xFF00D9FF),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Ensuring Safety Through Innovation',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withAlpha(
                                  243,
                                ), // 0.95 * 255
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
