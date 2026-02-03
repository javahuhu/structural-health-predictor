import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:structural_health_predictor/Features/AssesmentDetail/Data/Model/assesment_model.dart';
import 'package:structural_health_predictor/Features/AssesmentDetail/Domain/Entities/assessment_entity.dart';
import 'package:structural_health_predictor/Features/Dashboard/Presentation/Page/dashboard.dart';
import 'package:structural_health_predictor/Features/Profile/Presentation/Page/profile_page.dart';
import 'package:structural_health_predictor/Features/Scanner/Presentation/Page/scanner_page.dart';
import 'package:structural_health_predictor/Features/Settings/Presentation/Page/settings_page.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;
  AssessmentEntity? _currentAssessment;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();

    // 🔥 TEMP / DEBUG: inject dummy assessment
    _currentAssessment = AssessmentEntity(
      id: '1',
      name: 'Concrete Beam – Sample Scan',
      imagePath: 'assets/images/inkcolor.jpg',
      timestamp: DateTime.now(),
      crackData: CrackDataModel.sample(),
    );

    _updatePages();
  }

  void _updatePages() {
    _pages.clear();
    _pages.addAll([
      DashboardPage(currentAssessment: _currentAssessment),
      ScannerPage(onAssessmentSaved: _handleAssessmentSaved),
      ProfilePage(savedAssessments: [_currentAssessment!]),
      const SettingsPage(),
    ]);
  }

  void _handleAssessmentSaved(AssessmentEntity assessment) {
    setState(() {
      _currentAssessment = assessment;
      _updatePages();
      _currentIndex = 0; // Navigate back to dashboard
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: Stack(
          children: [
            IndexedStack(index: _currentIndex, children: _pages),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: const Color.fromARGB(
                            255,
                            24,
                            23,
                            23,
                          ).withValues(alpha: 0.05),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 12.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildNavItem(
                              icon: Icons.dashboard_rounded,
                              label: 'Reports',
                              index: 0,
                            ),
                            _buildNavItem(
                              icon: Icons.camera_alt_rounded,
                              label: 'Scanner',
                              index: 1,
                            ),
                            _buildNavItem(
                              icon: Icons.person_rounded,
                              label: 'Profile',
                              index: 2,
                            ),
                            _buildNavItem(
                              icon: Icons.settings_rounded,
                              label: 'Settings',
                              index: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF0F3460).withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF0F3460)
                  : const Color(0xFF1A1A2E).withValues(alpha: 1),
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF0F3460)
                    : const Color(0xFF1A1A2E).withValues(alpha: 0.4),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
