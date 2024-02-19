import 'package:flutter/material.dart';

void main() {
  runApp(const MeningiomaScreen());
}

class MeningiomaScreen extends StatelessWidget {
  const MeningiomaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Meningioma Treatment Guidelines'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: const <Widget>[
            GuidelineItem(
              title: "Observation",
              indication: "Small, asymptomatic meningiomas with slow or no growth.",
              approach: "Periodic imaging scans for growth monitoring.",
              outcome: "Treatment may not be required if there is no significant growth or development of symptoms.",
            ),
            GuidelineItem(
              title: "Surgery",
              indication: "Larger or symptomatic meningiomas.",
              procedure: "Neurosurgical resection with the goal of complete tumor removal while preserving neurological function.",
              method: "May involve a craniotomy to access the tumor.",
            ),
            GuidelineItem(
              title: "Radiation Therapy",
              indication: "Cases where complete surgical resection is infeasible or for recurring tumors.",
              types: "External beam radiation and stereotactic radiosurgery (e.g., Gamma Knife or CyberKnife).",
              objective: "Target residual tumor cells post-surgery.",
            ),
            GuidelineItem(
              title: "Hormone Therapy",
              indication: "Hormone receptor-positive meningiomas, such as estrogen or progesterone receptor-positive.",
              approach: "Medications like somatostatin analogs (e.g., octreotide) to slow tumor growth.",
            ),
            GuidelineItem(
              title: "Chemotherapy",
              indication: "Rarely considered; typically not effective for meningiomas.",
              use: "When other treatments have failed, and in select cases.",
            ),
            GuidelineItem(
              title: "Clinical Trials",
              indication: "Patients with recurrent, aggressive, or treatment-resistant meningiomas.",
              opportunity: "Participation in trials exploring innovative treatments and therapies.",
            ),
            GuidelineItem(
              title: "Rehabilitation",
              indication: "Post-surgery or radiation therapy; address neurological deficits and symptoms.",
              therapies: "Physical therapy, occupational therapy, or speech therapy, tailored to individual needs and impact of the tumor and treatment.",
            ),
          ],
        ),
      ),
    );
  }
}

class GuidelineItem extends StatelessWidget {
  final String title;
  final String indication;
  final String approach;
  final String outcome;
  final String procedure;
  final String method;
  final String types;
  final String objective;
  final String use;
  final String opportunity;
  final String therapies;

  const GuidelineItem({super.key, 
    required this.title,
    this.indication = "",
    this.approach = "",
    this.outcome = "",
    this.procedure = "",
    this.method = "",
    this.types = "",
    this.objective = "",
    this.use = "",
    this.opportunity = "",
    this.therapies = "",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        if (indication.isNotEmpty) Text("Indication: $indication"),
        if (approach.isNotEmpty) Text("Approach: $approach"),
        if (outcome.isNotEmpty) Text("Outcome: $outcome"),
        if (procedure.isNotEmpty) Text("Procedure: $procedure"),
        if (method.isNotEmpty) Text("Method: $method"),
        if (types.isNotEmpty) Text("Types: $types"),
        if (objective.isNotEmpty) Text("Objective: $objective"),
        if (use.isNotEmpty) Text("Use: $use"),
        if (opportunity.isNotEmpty) Text("Opportunity: $opportunity"),
        if (therapies.isNotEmpty) Text("Therapies: $therapies"),
        const Divider(thickness: 1.0),
      ],
    );
  }
}
