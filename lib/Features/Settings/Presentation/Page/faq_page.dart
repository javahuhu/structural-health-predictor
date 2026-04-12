import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  static const List<Map<String, String>> _faqs = [
    {
      'question': 'Are all cracks equally dangerous?',
      'answer':
          'During site inspections, cracks observed are not at all equal in any way, generally differentiated either that they are acceptable (Architectural) cracks that affect only the overall cosmetics of the surface or cracks that compromise the integrity (Structural) of a structure.',
    },
    {
      'question': 'How do Structural cracks differ from Architectural?',
      'answer':
          'Their main difference lies by how they affect the structural integrity of a building, followed by crack appearance. The depth of structural cracks (greater than 5mm) may reach a wall\'s internal reinforcements, damaging its foundation that compromises overall integrity. In contrast, the depth of architectural cracks (less than 5mm) may not reach any vital structural component of a wall, only its plaster, which is negligible depth to damage anything significant.',
    },
    {
      'question':
          'How important is depth in crack severity relative to length or width?',
      'answer':
          'Depth is the primary determiner on the estimation of Remaining Useful Life (RUL), a metric used in Structural Health Monitoring (SHM) as a prediction on how much longer a particular structure maintains integrity given the severity of a crack. Additionally, crack length determines how influential a crack can be to nearby cracks and width follows its trend in time, overall producing the appearance of crack progression.',
    },
    {
      'question': 'How long can the battery-powered device stay on?',
      'answer':
          'Depending on usage scenario, the device has an operational runtime of around 1.5 to 2 hours use complete with all of its crack capturing and analysis features as well as cloud synchronization.',
    },
    {
      'question': 'How can the device be charged?',
      'answer':
          'The device can be charged with a slide-on MT-21V Lithium Battery Charger for ease of charging, with a charging time of around 1 to 1.5 hours duration.',
    },
    {
      'question': 'Is this only applicable to concrete structures?',
      'answer':
          'Only concrete structures are supported for the crack analysis and RUL prediction features of the device for uniformity since non-concrete structures introduce more variables of concern such as roughness, type of structure, etc. which are looked upon by manual visual inspection.',
    },
    {
      'question':
          'What parameter is being used to differentiate Structural to Architectural?',
      'answer':
          'In the deep learning aspect of the device, the model has learned the visual features and physical characteristics of both crack classes. Aside from this, the combination of the Time of Flight (ToF) sensor and the Ultrasonic sensor (HC-SR104P) work together to assess the true crack depth.',
    },
    {
      'question':
          'How accurate is the crack detection and classification system?',
      'answer':
          'By relying on metrics such as the Intersection over Union (IoU) for the model, its classification performance safely reaches at least 95%, making it a reliable portable crack classifier and RUL predictor for quick and easier site inspections.',
    },
    {
      'question':
          'Can the device store or save captured crack data for future analysis?',
      'answer':
          'All cracks captured and analyzed are stored initially within the device\'s local database, including information such as the crack number, class, sync status, estimated RUL, and power (in watts). The user can decide to synchronize these records to the online database for portable in-app viewing with the mobile app.',
    },
    {
      'question':
          'How does your model avoid misclassification between structural and architectural crack?',
      'answer':
          'The trained model achieves a high score in accuracy metrics but does not guarantee perfect classifications like manual visual inspections, introducing a certain degree of minimal error. As a fallback measure, the device also reads the true crack depth to determine the type of crack as a backup in cases where model inferences become unreliable.',
    },
    {
      'question':
          'How does your system/device perform under different lighting or environmental conditions?',
      'answer':
          'It is recommended that the device be used in suitable lighting conditions for better classification efficiency in accuracy, even though the deep learning model used has been trained with various data augmentation techniques to adjust with several lighting conditions.',
    },
    {
      'question':
          'How close do I need to hold the device to the wall for an accurate reading?',
      'answer':
          'For best results, the device is recommended to be within 1 meter from the crack in observation to prevent unwanted noise when device readings are performed at longer distances.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'FAQ',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.help_outline_rounded,
                              color: colorScheme.primary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Frequently Asked Questions',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.onSurface,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Tap a question to expand its answer.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.60,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final faq = _faqs[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _FaqTile(
                      number: index + 1,
                      question: faq['question']!,
                      answer: faq['answer']!,
                    ),
                  );
                }, childCount: _faqs.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  final int number;
  final String question;
  final String answer;

  const _FaqTile({
    required this.number,
    required this.question,
    required this.answer,
  });

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isExpanded
              ? colorScheme.primary.withValues(alpha: 0.35)
              : theme.dividerColor,
        ),
        boxShadow: _isExpanded
            ? [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Theme(
        // Remove the default ExpansionTile divider
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          onExpansionChanged: (expanded) =>
              setState(() => _isExpanded = expanded),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          leading: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _isExpanded
                  ? colorScheme.primary.withValues(alpha: 0.15)
                  : colorScheme.onSurface.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${widget.number}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: _isExpanded
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.55),
              ),
            ),
          ),
          title: Text(
            widget.question,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _isExpanded ? colorScheme.primary : colorScheme.onSurface,
              letterSpacing: -0.1,
              height: 1.4,
            ),
          ),
          trailing: AnimatedRotation(
            turns: _isExpanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 250),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: _isExpanded
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.4),
              size: 22,
            ),
          ),
          children: [
            Divider(
              color: colorScheme.onSurface.withValues(alpha: 0.08),
              height: 1,
              thickness: 1,
            ),
            const SizedBox(height: 12),
            Text(
              widget.answer,
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.onSurface.withValues(alpha: 0.75),
                height: 1.6,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
