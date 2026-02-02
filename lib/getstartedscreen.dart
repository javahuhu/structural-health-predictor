import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:structural_health_predictor/Common/Cards/custom_container.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F0F0F),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomContainer(
                backgroundColor: Colors.transparent,
                boxShadow: [],
                margin: EdgeInsets.zero,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28.r),
                  child: Image.asset(
                    'assets/images/darkwall.jpg',
                    height: 325.h,
                    width: 1.sw,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Text(
                    'Structural Crack\nPre-Assessment',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.25,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 32.w, 0), // left indent
                  child: Text(
                    'Deep Learning–based crack classification\n'
                    'for early structural health assessment.\n'
                    'Predict damage before failure occurs.',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 60.h),

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: ElevatedButton(
                    onPressed: () => context.go('/signup'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 65, 75, 161),
                      padding: EdgeInsets.symmetric(
                        horizontal: 36.w,
                        vertical: 14.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Get Started  →',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.4,
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
}
