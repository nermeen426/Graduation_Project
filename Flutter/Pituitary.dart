import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PituitaryTreatmentScreen(),
    );
  }
}

class PituitaryTreatmentScreen extends StatelessWidget {
  const PituitaryTreatmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pituitary Treatment Guidelines'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TreatmentCategory(
                title: 'Non-Functional Pituitary Tumors:',
                treatments: [
                  Treatment(
                    title: 'Medication',
                    description:
                    'Indication: Non-functional tumors that do not secrete hormones.\n'
                        'Purpose: Control symptoms and potentially shrink the tumor.\n'
                        'Examples: Dopamine agonists (e.g., cabergoline) or somatostatin analogs.',
                  ),
                  Treatment(
                    title: 'Surgery',
                    description:
                    'Indication: Large tumors, neurological symptoms, or medication ineffectiveness.\n'
                        'Procedure: Transsphenoidal surgery for complete resection while preserving pituitary function.',
                  ),
                  Treatment(
                    title: 'Radiation Therapy',
                    description:
                    'Indication: Tumors not surgically accessible or at high risk of recurrence.\n'
                        'Methods: Post-surgery or as an alternative; stereotactic radiosurgery may be used.',
                  ),
                ],
              ),
              TreatmentCategory(
                title: 'Functional Pituitary Tumors:',
                treatments: [
                  Treatment(
                    title: 'Medication',
                    description:
                    'Indication: Hormone-secreting tumors (e.g., acromegaly or Cushing\'s disease).\n'
                        'Approach: Medication to control hormone levels.\n'
                        'Examples: Somatostatin analogs (e.g., octreotide) tailored to the specific hormone overproduction.',
                  ),
                  Treatment(
                    title: 'Surgery',
                    description:
                    'Indication: Functional pituitary tumors.\n'
                        'Procedure: Transsphenoidal surgery to achieve complete resection and normalize hormone levels.',
                  ),
                  Treatment(
                    title: 'Radiation Therapy',
                    description:
                    'Indication: Post-surgery or as a primary treatment option for hormone-secreting tumors.',
                  ),
                  Treatment(
                    title: 'Hormone Replacement Therapy',
                    description:
                    'Indication: Post-surgery, when the pituitary gland is affected, leading to hormonal deficiencies.',
                  ),
                  Treatment(
                    title: 'Regular Monitoring',
                    description:
                    'Requirement: Long-term monitoring to assess hormone levels and detect tumor recurrence.',
                  ),
                  Treatment(
                    title: 'Rehabilitation',
                    description:
                    'Indication: To address hormone-related symptoms and neurological deficits, depending on the tumor\'s impact.',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TreatmentCategory extends StatelessWidget {
  final String title;
  final List<Treatment> treatments;

  const TreatmentCategory({super.key, required this.title, required this.treatments});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Column(
          children: treatments.map((treatment) {
            return TreatmentCard(treatment: treatment);
          }).toList(),
        ),
      ],
    );
  }
}

class Treatment {
  final String title;
  final String description;

  Treatment({required this.title, required this.description});
}

class TreatmentCard extends StatelessWidget {
  final Treatment treatment;

  const TreatmentCard({super.key, required this.treatment});

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
              treatment.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(treatment.description),
          ],
        ),
      ),
    );
  }
}
