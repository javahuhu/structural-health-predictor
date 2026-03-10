import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:structural_health_predictor/Features/AssesmentDetail/Domain/Entities/assessment_entity.dart';

class DashboardPage extends StatelessWidget {
  final InspectionLog? selectedLog;
  final VoidCallback? onDashboardBack;

  const DashboardPage({
    super.key,
    this.selectedLog,
    this.onDashboardBack,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) onDashboardBack?.call();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: SafeArea(
            child: selectedLog == null
                ? _buildEmptyState()
                : _buildDashboardContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF0F3460).withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.assessment_outlined,
              size: 80,
              color: const Color(0xFF0F3460).withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Current Assessment',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F0F0F),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Select a record to view its dashboard',
            style: TextStyle(
              fontSize: 15,
              color: const Color(0xFF1A1A2E).withOpacity(0.6),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    final log = selectedLog!;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      onPressed: onDashboardBack,
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Color(0xFF0F3460),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      'DASHBOARD',
                      style: TextStyle(
                        fontSize: 35.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F0F0F),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Crack Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: log.imageUrl,
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: double.infinity,
                      height: 220,
                      color: const Color(0xFF0F3460).withOpacity(0.05),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF0F3460),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: double.infinity,
                      height: 220,
                      color: const Color(0xFF0F3460).withOpacity(0.1),
                      child: const Icon(
                        Icons.image_outlined,
                        color: Color(0xFF0F3460),
                        size: 64,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Device + Timestamp
                Text(
                  log.deviceId,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F3460),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(log.timestamp),
                  style: TextStyle(
                    fontSize: 13,
                    color: const Color(0xFF1A1A2E).withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 24),

                // Type badge
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _getTypeColor(log.type),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.warning_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            log.type,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Metrics Grid
                const Text(
                  'Inspection Metrics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F0F0F),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        title: 'Device ID',
                        value: log.deviceId,
                        icon: Icons.device_hub_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricCard(
                        title: 'Crack Type',
                        value: log.type,
                        icon: Icons.warning_amber_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        title: 'Power (W)',
                        value: log.powerW.toStringAsFixed(2),
                        icon: Icons.bolt_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricCard(
                        title: 'RUL (Days)',
                        value: '${log.rulDays}',
                        icon: Icons.timer_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Depth card
                const Text(
                  'Crack Measurement',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F0F0F),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 16),

                _buildDepthCard(log.depthCm),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0F3460).withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF0F3460)),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1A1A2E).withOpacity(0.6),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F0F0F),
              height: 1.2,
              letterSpacing: -0.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDepthCard(double depthCm) {
    // Normalize depth for visual bar — assuming max meaningful depth is 20cm
    final normalized = (depthCm / 20.0).clamp(0.0, 1.0);
    final color = depthCm > 10
        ? const Color(0xFFFF6B6B)
        : depthCm > 5
            ? const Color(0xFFFF9F40)
            : const Color(0xFF4ECDC4);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.vertical_align_center_rounded,
                      size: 20,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Depth',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F0F0F),
                    ),
                  ),
                ],
              ),
              Text(
                '${depthCm.toStringAsFixed(2)} cm',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: color,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: normalized,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0 cm',
                style: TextStyle(
                  fontSize: 11,
                  color: const Color(0xFF1A1A2E).withOpacity(0.4),
                ),
              ),
              Text(
                '20 cm',
                style: TextStyle(
                  fontSize: 11,
                  color: const Color(0xFF1A1A2E).withOpacity(0.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'structural':
        return const Color(0xFFFF9F40);
      case 'architectural':
        return const Color(0xFFFF6B6B);
      default:
        return const Color(0xFF0F3460);
    }
  }
}