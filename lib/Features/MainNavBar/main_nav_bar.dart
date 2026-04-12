import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:structural_health_predictor/Features/Dashboard/Domain/Entities/inspection_log_entity.dart';
import 'package:structural_health_predictor/Features/Dashboard/Presentation/Bloc/dashboard_bloc.dart';
import 'package:structural_health_predictor/Features/Dashboard/Presentation/Bloc/dashboard_event.dart';
import 'package:structural_health_predictor/Features/Dashboard/Presentation/Bloc/dashboard_state.dart';
import 'package:structural_health_predictor/Features/Dashboard/Presentation/Page/dashboard.dart';
import 'package:structural_health_predictor/Features/Profile/Presentation/Page/profile_page.dart';
import 'package:structural_health_predictor/Features/Settings/Presentation/Page/settings_page.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 1;
  InspectionLog? _selectedLog;
  int? _selectedRecordNumber;
  bool _isDashboardAccessible = false;

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const DashboardStarted());
  }

  void _onSelectLog(InspectionLog log, int index) {
    setState(() {
      _selectedLog = log;
      _selectedRecordNumber = index + 1;
      _currentIndex = 0;
      _isDashboardAccessible = true;
    });
  }

  void _clearDashboard() {
    setState(() {
      _selectedLog = null;
      _selectedRecordNumber = null;
      _isDashboardAccessible = false;
      _currentIndex = 1;
    });
  }

  InspectionLog? _resolveSelectedLog(List<InspectionLog> logs) {
    final selectedLog = _selectedLog;
    if (selectedLog == null) return null;

    for (final log in logs) {
      if (log.id == selectedLog.id) {
        return log;
      }
    }

    return selectedLog;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final logs = state.logs;
        final errorMessage = state.errorMessage;
        final selectedLog = _resolveSelectedLog(logs);

        final pages = [
          DashboardPage(
            selectedLog: selectedLog,
            selectedRecordNumber: _selectedRecordNumber,
            onDashboardBack: _clearDashboard,
          ),
          RecordsPage(
            logs: logs,
            isLoading: state.isLoading,
            isRefreshing: state.isRefreshing,
            isLoadingMore: state.isLoadingMore,
            hasMore: state.hasMore,
            errorMessage: errorMessage,
            onSelectLog: _onSelectLog,
            onRefresh: () => context.read<DashboardBloc>().refreshLogs(),
            onLoadMore: () {
              context.read<DashboardBloc>().add(
                const DashboardLoadMoreRequested(),
              );
            },
          ),
          const SettingsPage(),
        ];

        return Scaffold(
          body: PopScope(
            canPop: false,
            child: Stack(
              children: [
                IndexedStack(index: _currentIndex, children: pages),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 15.h,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999.r),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorScheme.surface.withValues(alpha: 0.24),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: theme.dividerColor,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.07),
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
                                  icon: Icons.person_rounded,
                                  label: 'Records',
                                  index: 1,
                                ),
                                _buildNavItem(
                                  icon: Icons.dashboard_rounded,
                                  label: 'Reports',
                                  index: 0,
                                ),
                                _buildNavItem(
                                  icon: Icons.settings_rounded,
                                  label: 'Settings',
                                  index: 2,
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
      },
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        if (index == 0 && !_isDashboardAccessible) return;
        setState(() => _currentIndex = index);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 3.h),
      //  decoration: BoxDecoration(
      //     color: isSelected
      //         ? colorScheme.primary.withValues(alpha: 0.14)
      //         : Colors.transparent,
      //     borderRadius: BorderRadius.circular(18.r),
      //   ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? colorScheme.primary
                  : index == 0 && !_isDashboardAccessible
                      ? theme.disabledColor
                      : colorScheme.onSurface,
              size: 22.r,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
