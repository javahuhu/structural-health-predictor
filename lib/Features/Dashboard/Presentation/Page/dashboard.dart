import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:structural_health_predictor/Features/AssesmentDetail/Domain/Entities/assessment_entity.dart';


class DashboardPage extends StatelessWidget {
  final AssessmentEntity? currentAssessment;

  const DashboardPage({super.key, this.currentAssessment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80), // Add this padding
        child: SafeArea(
          child: currentAssessment == null
              ? _buildEmptyState()
              : _buildDashboardContent(),
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
          Text(
            'No Current Assessment',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F0F0F),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Capture an image to start analyzing',
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
    final data = currentAssessment!.crackData;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DASHBOARD',
                  style: TextStyle(
                    fontSize: 35.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F0F0F),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  currentAssessment!.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF0F3460),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 35),

                // Filter Row
                Row(
                  children: [
                    _buildFilterChip('All-time'),
                    const SizedBox(width: 12),
                    _buildFilterChip('All', isOutline: true),
                    const SizedBox(width: 12),
                    _buildFilterChip('All', isOutline: true),
                  ],
                ),
                const SizedBox(height: 24),

                // Top Metrics
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        title: 'Deep Learning Model:',
                        value: data.model,
                        subtitle: '',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricCard(
                        title: 'Accuracy:',
                        value: '${data.accuracy}%',
                        subtitle: '',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        title: 'Runtime:',
                        value: data.runtime,
                        subtitle: '',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricCard(
                        title: 'Severity Level',
                        value: data.severityLevel,
                        subtitle: '',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Gain Metrics
                Row(
                  children: [
                    Expanded(
                      child: _buildGainCard(
                        title: 'Width Gain',
                        percentage: data.widthGain,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildGainCard(
                        title: 'Length Gain',
                        percentage: data.lengthGain,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildGainCard(
                        title: 'Depth Gain',
                        percentage: data.depthGain,
                        isPositive: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Chart
                _buildChartCard(data.dailyData),
                const SizedBox(height: 24),

                // Parameters
                _buildParametersCard(data.parameters),
                const SizedBox(height: 24),

                // Performance Metrics
                _buildPerformanceCard(data.performanceMetrics),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, {bool isOutline = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isOutline
            ? Colors.white
            : const Color(0xFF0F3460).withOpacity(0.08),
        border: isOutline
            ? Border.all(color: const Color(0xFF1A1A2E).withOpacity(0.2))
            : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF0F0F0F),
              letterSpacing: 0.2,
            ),
          ),
          if (isOutline) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: const Color(0xFF0F0F0F),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
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
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1A1A2E).withOpacity(0.6),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F0F0F),
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGainCard({
    required String title,
    required double percentage,
    bool isPositive = false,
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
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1A1A2E).withOpacity(0.6),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${percentage.toInt()}%',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F0F0F),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          // Wave indicator
          CustomPaint(
            size: const Size(double.infinity, 20),
            painter: WavePainter(isPositive: isPositive),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(List<DailyData> data) {
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
              Text(
                'Day',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A2E).withOpacity(0.6),
                  letterSpacing: 0.3,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: const Color(0xFF1A1A2E).withOpacity(0.6),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 800,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < data.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              data[value.toInt()].day.split(' ')[1],
                              style: TextStyle(
                                fontSize: 10,
                                color: const Color(0xFF1A1A2E).withOpacity(0.4),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color: const Color(0xFF1A1A2E).withOpacity(0.4),
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 200,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: const Color(0xFF1A1A2E).withOpacity(0.05),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: data.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.value,
                        color: const Color(0xFF0F3460),
                        width: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParametersCard(Map<String, double> parameters) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Parameters',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F0F0F),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 20),
          ...parameters.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildProgressBar(
                label: entry.key,
                value: entry.value,
                color: entry.key == 'Width'
                    ? const Color(0xFFFF6B6B)
                    : const Color(0xFFFF9F40),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard(Map<String, double> metrics) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Metrics',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F0F0F),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 20),
          ...metrics.entries.map((entry) {
            Color color;
            if (entry.key == 'Recall') {
              color = const Color.fromARGB(255, 146, 206, 202);
            } else if (entry.key == 'F1 Score') {
              color = const Color(0xFF0F3460);
            } else {
              color = const Color.fromARGB(255, 109, 91, 214);
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildProgressBar(
                label: entry.key,
                value: entry.value,
                color: color,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildProgressBar({
    required String label,
    required double value,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.analytics_outlined, size: 16, color: color),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF0F0F0F),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
            Text(
              '${value.toInt()}%',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F0F0F),
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
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

class WavePainter extends CustomPainter {
  final bool isPositive;

  WavePainter({required this.isPositive});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isPositive ? const Color(0xFF4ECDC4) : const Color(0xFF0F3460)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final waveHeight = size.height * 0.3;
    final waveWidth = size.width / 4;

    path.moveTo(0, size.height / 2);

    for (double i = 0; i < size.width; i += waveWidth) {
      path.quadraticBezierTo(
        i + waveWidth / 2,
        size.height / 2 - waveHeight,
        i + waveWidth,
        size.height / 2,
      );
      if (i + waveWidth < size.width) {
        path.quadraticBezierTo(
          i + waveWidth * 1.5,
          size.height / 2 + waveHeight,
          i + waveWidth * 2,
          size.height / 2,
        );
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
