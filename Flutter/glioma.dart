import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GliomaTreatmentScreen(),
    );
  }
}

class GliomaTreatmentScreen extends StatelessWidget {
  const GliomaTreatmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Glioma Treatment Guidelines'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TreatmentItem(
                title: 'Surgery',
                description:
                'Description: The initial step in glioma treatment.\n'
                    'Objective: Complete glioma removal; "subtotal resection" in complex cases.\n'
                    'Risks: Infection, bleeding, location-specific complications.\n'
                    'Key: Preoperative evaluation and meticulous planning.',
              ),
              TreatmentItem(
                title: 'Radiation Therapy',
                description:
                'Description: Uses high-energy beams to target and destroy tumor cells.\n'
                    'Role: Typically follows surgery, possibly with chemotherapy.\n'
                    'Common Side Effects: Fatigue, scalp irritation, hair loss.',
              ),
              TreatmentItem(
                title: 'Chemotherapy',
                description:
                'Description: Employs drugs in pill, IV, or direct application forms.\n'
                    'Combination: Often used with radiation therapy.\n'
                    'Common Side Effects: Nausea, hair loss, fever, fatigue (managed with medications).',
              ),
              TreatmentItem(
                title: 'Tumor Treating Fields Therapy',
                description:
                'Description: Utilizes electrical energy to disrupt glioma cell growth, primarily for glioblastoma.\n'
                    'Concurrent Use: Administered alongside chemotherapy.\n'
                    'Notable Side Effect: Skin irritation at the application site.',
              ),
              TreatmentItem(
                title: 'Targeted Therapy',
                description:
                'Description: Targets specific molecules within cancer cells, causing cell death.\n'
                    'Personalized: Based on glioma cell testing.\n'
                    'Use: Post-surgery for slow-growing gliomas or after standard treatments fail.\n'
                    'Side Effects: Vary by medication and dosage.',
              ),
              TreatmentItem(
                title: 'Rehabilitation After Treatment',
                description:
                'Purpose: Essential for restoring brain function.\n'
                    'Includes: Physical therapy, occupational therapy, speech therapy, and tutoring for school-age children.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TreatmentItem extends StatelessWidget {
  final String title;
  final String description;

  const TreatmentItem({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(description),
          ],
        ),
      ),
    );
  }
}
