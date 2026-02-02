import 'package:flutter/material.dart';
import 'dart:math' as math;



class CrackDetectionApp extends StatelessWidget {
  const CrackDetectionApp({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SHM Crack Detection',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        primaryColor: const Color(0xFF0F3460),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF0F3460),
          secondary: Color(0xFF16213E),
          surface: Color(0xFF1A1A2E),
          background: Color(0xFF0F0F0F),
        ),
        fontFamily: 'Roboto',
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const DetectionScreen(),
    const HistoryScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F3460).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
           backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedItemColor: const Color(0xFF00D9FF),
            unselectedItemColor: Colors.grey,
            selectedFontSize: 12,
            unselectedFontSize: 10,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt_rounded),
                label: 'Detect',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history_rounded),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_rounded),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// DASHBOARD SCREEN
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // App Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'SHM System',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Structural Health Monitoring',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A2E),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color(0xFF0F3460).withOpacity(0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.notifications_rounded,
                          color: Color(0xFF00D9FF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // System Status Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F3460), Color(0xFF16213E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F3460).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Color(0xFF00FF88),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF00FF88),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'System Active',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatusInfo('Model', 'YOLOv8s'),
                        _buildStatusInfo('Device', 'Raspberry Pi 5'),
                        _buildStatusInfo('Status', 'Ready'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Performance Metrics
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Performance Metrics',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          'Accuracy',
                          '37.6%',
                          'mAP50',
                          Icons.speed_rounded,
                          const Color(0xFF00D9FF),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildMetricCard(
                          'Latency',
                          '4.6ms',
                          'Inference',
                          Icons.timer_rounded,
                          const Color(0xFFFF6B9D),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          'Power',
                          '7.04W',
                          'Consumption',
                          Icons.bolt_rounded,
                          const Color(0xFFFFA500),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildMetricCard(
                          'GFLOPS',
                          '42.4',
                          'Efficiency',
                          Icons.memory_rounded,
                          const Color(0xFF00FF88),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Detection Statistics
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detection Statistics',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF0F3460).withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildStatRow(
                          'Total Detections',
                          '247',
                          Icons.analytics_rounded,
                          const Color(0xFF00D9FF),
                        ),
                        const Divider(height: 30, color: Color(0xFF16213E)),
                        _buildStatRow(
                          'Structural Cracks',
                          '143',
                          Icons.warning_rounded,
                          const Color(0xFFFF6B9D),
                        ),
                        const Divider(height: 30, color: Color(0xFF16213E)),
                        _buildStatRow(
                          'Architectural Cracks',
                          '104',
                          Icons.info_rounded,
                          const Color(0xFFFFA500),
                        ),
                        const Divider(height: 30, color: Color(0xFF16213E)),
                        _buildStatRow(
                          'This Week',
                          '32',
                          Icons.calendar_today_rounded,
                          const Color(0xFF00FF88),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Model Information
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Model Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF0F3460).withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow('Architecture', 'YOLOv8s'),
                        const SizedBox(height: 15),
                        _buildInfoRow('Model Size', '22.7 MB'),
                        const SizedBox(height: 15),
                        _buildInfoRow('Dataset', '5000+ Images'),
                        const SizedBox(height: 15),
                        _buildInfoRow('Classes', 'Structural & Architectural'),
                        const SizedBox(height: 15),
                        _buildInfoRow('Framework', 'PyTorch / ONNX'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Recent Activity
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Activity',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'View All',
                          style: TextStyle(color: Color(0xFF00D9FF)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildActivityItem(
                    'Structural Crack Detected',
                    'Building A - Floor 3',
                    '2 hours ago',
                    Icons.warning_rounded,
                    const Color(0xFFFF6B9D),
                  ),
                  const SizedBox(height: 10),
                  _buildActivityItem(
                    'Architectural Crack Detected',
                    'Building B - Floor 1',
                    '5 hours ago',
                    Icons.info_rounded,
                    const Color(0xFFFFA500),
                  ),
                  const SizedBox(height: 10),
                  _buildActivityItem(
                    'System Calibration Complete',
                    'All sensors active',
                    '1 day ago',
                    Icons.check_circle_rounded,
                    const Color(0xFF00FF88),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildStatusInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[400],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    String title,
    String subtitle,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF0F3460).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

// DETECTION SCREEN
class DetectionScreen extends StatefulWidget {
  const DetectionScreen({super.key});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  bool _isDetecting = false;
  String? _detectionResult;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Crack Detection',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Capture or upload an image for analysis',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 30),
            
            // Camera Preview Area
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF0F3460).withOpacity(0.3),
                  ),
                ),
                child: _isDetecting
                    ? _buildDetectionResult()
                    : _buildCameraPlaceholder(),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'Upload Image',
                    Icons.photo_library_rounded,
                    const Color(0xFF0F3460),
                    () {
                      // Upload image logic
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildActionButton(
                    'Capture',
                    Icons.camera_alt_rounded,
                    const Color(0xFF00D9FF),
                    () {
                      setState(() {
                        _isDetecting = true;
                        _detectionResult = 'Structural';
                      });
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt_rounded,
            size: 80,
            color: Colors.grey[700],
          ),
          const SizedBox(height: 20),
          Text(
            'Ready to detect cracks',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Capture or upload an image',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectionResult() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mock image placeholder
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0F0F0F),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Icon(
                  Icons.image_rounded,
                  size: 100,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Results
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _detectionResult == 'Structural'
                    ? [const Color(0xFFFF6B9D).withOpacity(0.2), const Color(0xFFFF6B9D).withOpacity(0.1)]
                    : [const Color(0xFFFFA500).withOpacity(0.2), const Color(0xFFFFA500).withOpacity(0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: _detectionResult == 'Structural'
                    ? const Color(0xFFFF6B9D).withOpacity(0.5)
                    : const Color(0xFFFFA500).withOpacity(0.5),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _detectionResult == 'Structural' 
                      ? Icons.warning_rounded 
                      : Icons.info_rounded,
                  color: _detectionResult == 'Structural'
                      ? const Color(0xFFFF6B9D)
                      : const Color(0xFFFFA500),
                  size: 32,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detection Result',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$_detectionResult Crack',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _detectionResult == 'Structural'
                        ? const Color(0xFFFF6B9D)
                        : const Color(0xFFFFA500),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '87.3%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// HISTORY SCREEN
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Detection History',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'View all past crack detections',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          
          // Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', true),
                  const SizedBox(width: 10),
                  _buildFilterChip('Structural', false),
                  const SizedBox(width: 10),
                  _buildFilterChip('Architectural', false),
                  const SizedBox(width: 10),
                  _buildFilterChip('This Week', false),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // History List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 10,
              itemBuilder: (context, index) {
                final isStructural = index % 3 == 0;
                return _buildHistoryItem(
                  context,
                  'Detection #${247 - index}',
                  isStructural ? 'Structural Crack' : 'Architectural Crack',
                  'Building ${['A', 'B', 'C'][index % 3]} - Floor ${index % 5 + 1}',
                  '${index + 1} ${index < 7 ? 'hours' : 'days'} ago',
                  isStructural,
                  '${85 + index % 10}.${index % 10}%',
                );
              },
            ),
          ),
          
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF0F3460) : const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected 
              ? const Color(0xFF00D9FF) 
              : const Color(0xFF0F3460).withOpacity(0.3),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? const Color(0xFF00D9FF) : Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(
    BuildContext context,
    String id,
    String type,
    String location,
    String time,
    bool isStructural,
    String confidence,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF0F3460).withOpacity(0.3),
        ),
      ),
      child: InkWell(
        onTap: () {
          _showDetailDialog(context, id, type, location, time, isStructural, confidence);
        },
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF0F0F0F),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.image_rounded,
                color: Colors.grey[800],
                size: 30,
              ),
            ),
            
            const SizedBox(width: 15),
            
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          id,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isStructural 
                              ? const Color(0xFFFF6B9D).withOpacity(0.2)
                              : const Color(0xFFFFA500).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isStructural 
                                ? const Color(0xFFFF6B9D)
                                : const Color(0xFFFFA500),
                          ),
                        ),
                        child: Text(
                          confidence,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isStructural 
                                ? const Color(0xFFFF6B9D)
                                : const Color(0xFFFFA500),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    type,
                    style: TextStyle(
                      fontSize: 14,
                      color: isStructural 
                          ? const Color(0xFFFF6B9D)
                          : const Color(0xFFFFA500),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailDialog(
    BuildContext context,
    String id,
    String type,
    String location,
    String time,
    bool isStructural,
    String confidence,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    id,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    color: Colors.grey,
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Image preview
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F0F0F),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Icon(
                    Icons.image_rounded,
                    size: 80,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              _buildDetailRow('Type', type, isStructural),
              const Divider(height: 30, color: Color(0xFF16213E)),
              _buildDetailRow('Location', location, null),
              const Divider(height: 30, color: Color(0xFF16213E)),
              _buildDetailRow('Confidence', confidence, null),
              const Divider(height: 30, color: Color(0xFF16213E)),
              _buildDetailRow('Detected', time, null),
              const Divider(height: 30, color: Color(0xFF16213E)),
              _buildDetailRow('Model', 'YOLOv8s', null),
              
              const SizedBox(height: 20),
              
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share_rounded, size: 18),
                      label: const Text('Share'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F3460),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.delete_rounded, size: 18),
                      label: const Text('Delete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B9D).withOpacity(0.2),
                        foregroundColor: const Color(0xFFFF6B9D),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool? isStructural) {
    Color? valueColor;
    if (isStructural != null) {
      valueColor = isStructural ? const Color(0xFFFF6B9D) : const Color(0xFFFFA500);
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? Colors.white,
          ),
        ),
      ],
    );
  }
}

// SETTINGS SCREEN
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Configure your detection system',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Model Settings
          const Text(
            'Model Configuration',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          _buildSettingCard(
            'Model Selection',
            'YOLOv8s',
            Icons.psychology_rounded,
            const Color(0xFF00D9FF),
            onTap: () {},
          ),
          const SizedBox(height: 10),
          _buildSettingCard(
            'Confidence Threshold',
            '75%',
            Icons.tune_rounded,
            const Color(0xFFFF6B9D),
            onTap: () {},
          ),
          
          const SizedBox(height: 30),
          
          // Device Settings
          const Text(
            'Device Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          _buildSettingCard(
            'Camera Resolution',
            '1920x1080',
            Icons.camera_rounded,
            const Color(0xFFFFA500),
            onTap: () {},
          ),
          const SizedBox(height: 10),
          _buildSettingCard(
            'Storage Location',
            'Local Database',
            Icons.storage_rounded,
            const Color(0xFF00FF88),
            onTap: () {},
          ),
          
          const SizedBox(height: 30),
          
          // About
          const Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          _buildSettingCard(
            'Version',
            'v1.0.0',
            Icons.info_rounded,
            const Color(0xFF0F3460),
            onTap: () {},
          ),
          const SizedBox(height: 10),
          _buildSettingCard(
            'Documentation',
            'View Guidelines',
            Icons.book_rounded,
            const Color(0xFF0F3460),
            onTap: () {},
          ),
          const SizedBox(height: 10),
          _buildSettingCard(
            'Team Information',
            'TIP Team 5',
            Icons.group_rounded,
            const Color(0xFF0F3460),
            onTap: () {},
          ),
          
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSettingCard(
    String title,
    String value,
    IconData icon,
    Color color,
    {VoidCallback? onTap}
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF0F3460).withOpacity(0.3),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}