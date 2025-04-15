import 'package:flutter/material.dart';
import 'package:uts_aplication/models/uts_models.dart';
import 'package:uts_aplication/services/api.dart';
import 'package:uts_aplication/pages/detailbyid.dart';

class DetailByNimPage extends StatefulWidget {
  final String nim;

  const DetailByNimPage({super.key, required this.nim});

  @override
  State<DetailByNimPage> createState() => _DetailByNimPageState();
}

class _DetailByNimPageState extends State<DetailByNimPage> {
  late Future<List<Report>> _reportList;

  @override
  void initState() {
    super.initState();
    _reportList = DataListService().fetchReportsByNim(widget.nim);
  }

  void _navigateToDetailById(String nim, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailByIdPage(nim: nim, id: id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reports by NIM: ${widget.nim}")),
      body: FutureBuilder<List<Report>>(
        future: _reportList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No reports found.'));
          }

          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final report = data[index];
              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(report.titleIssues),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Division: ${report.divisionDepartmentName}'),
                      Text('Priority: ${report.priorityName}'),
                      Text('Rating: ${report.rating}'),
                      const SizedBox(height: 4),
                      Text('Description: ${report.descriptionIssues}'),
                    ],
                  ),
                  onTap: () => _navigateToDetailById(report.nim, report.idCustomerService),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
