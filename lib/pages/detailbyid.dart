import 'package:flutter/material.dart';
import 'package:uts_aplication/models/uts_models.dart';
import 'package:uts_aplication/services/api.dart';

class DetailByIdPage extends StatelessWidget {
  final String nim;
  final String id;

  const DetailByIdPage({super.key, required this.nim, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report Detail")),
      body: FutureBuilder<Report>(
        future: DataListService().fetchReportByNimAndId(nim, int.parse(id)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load data:\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Data not found."));
          }

          final report = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NIM: ${report.nim}', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Title: ${report.titleIssues}'),
                Text('Division: ${report.divisionDepartmentName}'),
                Text('Priority: ${report.priorityName}'),
                Text('Rating: ${report.rating}'),
                const SizedBox(height: 12),
                const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(report.descriptionIssues),
              ],
            ),
          );
        },
      ),
    );
  }
}
