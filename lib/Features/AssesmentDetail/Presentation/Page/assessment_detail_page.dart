import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:structural_health_predictor/Features/AssesmentDetail/Domain/Entities/assessment_entity.dart';

class AssessmentDetailPage extends StatelessWidget {
  final AssessmentEntity assessment;

  const AssessmentDetailPage({super.key, required this.assessment});

  @override
  Widget build(BuildContext context) {
    final data = assessment.crackData;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: const Color(0xFF0F0F0F)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          assessment.name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F0F0F),
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                assessment.imagePath,
                width: double.infinity,
                height: 280,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 280,
                    color: const Color(0xFF0F3460).withOpacity(0.1),
                    child: Icon(
                      Icons.image_outlined,
                      color: const Color(0xFF0F3460),
                      size: 64,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Date and Severity
            Row(
              children: [
                Expanded(
                  child: _buildInfoChip(
                    icon: Icons.calendar_today_outlined,
                    label: _formatDate(assessment.timestamp),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: _getSeverityColor(data.severityLevel),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        data.severityLevel,
                        style: TextStyle(
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

            // Analysis Summary
            // Text(
            //   'Analysis Summary',
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.w700,
            //     color: const Color(0xFF0F0F0F),
            //     letterSpacing: -0.4,
            //   ),
            // ),
            // const SizedBox(height: 16),


            // Row(
            //   children: [
            //     Expanded(
            //       child: _buildDetailCard(
            //         title: 'Accuracy',
            //         value: '${data.accuracy}%',
            //         icon: Icons.check_circle_outline,
            //       ),
            //     ),
            //     const SizedBox(width: 12),
            //     Expanded(
            //       child: _buildDetailCard(
            //         title: 'Runtime',
            //         value: data.runtime,
            //         icon: Icons.timer_outlined,
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 32),

            // Measurements
            Text(
              'Crack Measurements',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F0F0F),
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 16),

            _buildMeasurementCard(
              title: 'Width Gain',
              value: '${data.widthGain.toInt()} mm',
              icon: Icons.swap_horiz_rounded,
              color: const Color(0xFF0F3460),
            ),
            const SizedBox(height: 12),

            _buildMeasurementCard(
              title: 'Length Gain',
              value: '${data.lengthGain.toInt()} mm',
              icon: Icons.height_rounded,
              color: const Color(0xFF16213E),
            ),
            const SizedBox(height: 12),

            _buildMeasurementCard(
              title: 'Depth Gain',  
              value: '+${data.depthGain.toInt()} mm',
              icon: Icons.vertical_align_center_rounded,
              color: const Color(0xFF4ECDC4),
            ),
            const SizedBox(height: 32),

            // Performance
            Text(
              'Performance Metrics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F0F0F),
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 16),

            ...data.performanceMetrics.entries.map((entry) {
              return Padding(
                padding:  EdgeInsets.only(bottom: 25.h),
                child: _buildMetricBar(label: entry.key, value: entry.value),
              );
            }),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                 
                  Navigator.pop(context, {'navigateToDashboard': true});

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F3460),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'View Full On Dashboard',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
             SizedBox(height: 15.h),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF0F3460)),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F0F0F),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F3460).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: const Color(0xFF0F3460)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF1A1A2E).withOpacity(0.6),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F0F0F),
                    letterSpacing: -0.2,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBar({required String label, required double value}) {
    Color color;
    if (label == 'Recall') {
      color = const Color(0xFF4ECDC4);
    } else if (label == 'F1 Score') {
      color = const Color(0xFF0F3460);
    } else {
      color = const Color(0xFF95E1D3);
    }

    return Container(
      padding: const EdgeInsets.all(16),
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
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F0F0F),
                  letterSpacing: 0.2,
                ),
              ),
              Text(
                '${value.toInt()}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: color.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'Structural':
        return const Color(0xFFFF9F40);
      case 'Architectural':
        return const Color(0xFFFF6B6B);
      default:
        return const Color(0xFF0F3460);
    }
  }
}
