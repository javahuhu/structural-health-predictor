import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:structural_health_predictor/Features/AssesmentDetail/Domain/Entities/assessment_entity.dart';
import 'package:structural_health_predictor/Features/AssesmentDetail/Presentation/Page/assessment_detail_page.dart';


class RecordsPage extends StatelessWidget {
  final List<InspectionLog> logs;
  final bool isLoading;
  final String? errorMessage;
  final Function(InspectionLog) onSelectLog;
  final VoidCallback onNavigateToDashboard;

  const RecordsPage({
    super.key,
    required this.logs,
    required this.isLoading,
    this.errorMessage,
    required this.onSelectLog,
    required this.onNavigateToDashboard,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Records',
                        style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F0F0F),
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: 60.h),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              label: 'Assessments',
                              value: logs.length.toString(),
                              icon: Icons.assessment_outlined,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              label: 'This Month',
                              value: _countThisMonth(logs).toString(),
                              icon: Icons.calendar_today_outlined,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Inspection Logs',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F0F0F),
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        '${logs.length}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F3460),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF0F3460),
                    ),
                  ),
                )
              else if (errorMessage != null)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.05),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Error Loading Data',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F0F0F),
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.red.withValues(alpha: 0.7),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (logs.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F3460).withValues(alpha: 0.05),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.photo_library_outlined,
                            size: 64,
                            color: const Color(0xFF0F3460).withValues(alpha: 0.3),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No Inspection Logs',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F0F0F),
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No data found in Firestore yet',
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFF1A1A2E).withValues(alpha: 0.6),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 125),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final log = logs[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildLogTile(context, log),
                        );
                      },
                      childCount: logs.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogTile(BuildContext context, InspectionLog log) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          onSelectLog(log);
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AssessmentDetailPage(log: log),
            ),
          );
          if (result != null &&
              result is Map &&
              result['navigateToDashboard'] == true) {
            onNavigateToDashboard();
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Network image from Cloudinary
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: log.imageUrl,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 72,
                    height: 72,
                    color: const Color(0xFF0F3460).withValues(alpha: 0.05),
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF0F3460),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 72,
                    height: 72,
                    color: const Color(0xFF0F3460).withValues(alpha: 0.1),
                    child: const Icon(
                      Icons.image_outlined,
                      color: Color(0xFF0F3460),
                      size: 32,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log.deviceId,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F0F0F),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(log.timestamp),
                      style: TextStyle(
                        fontSize: 13,
                        color: const Color(0xFF1A1A2E).withValues(alpha: 0.6),
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getTypeColor(log.type),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        log.type,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: const Color(0xFF1A1A2E).withValues(alpha: 0.3),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F3460).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: const Color(0xFF0F3460)),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F0F0F),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xFF1A1A2E).withValues(alpha: 0.6),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  int _countThisMonth(List<InspectionLog> logs) {
    final now = DateTime.now();
    return logs
        .where((l) => l.timestamp.month == now.month && l.timestamp.year == now.year)
        .length;
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
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