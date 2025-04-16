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
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            title: Text("Reports of NIM: ${widget.nim}"),
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<List<Report>>(
        future: _reportList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('❌ Failed to load: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No reports found.'));
          }

          final data = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final report = data[index];
              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.assignment, color: Colors.white),
                  ),
                  title: Text(
                    report.titleIssues,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text('Division: ${report.divisionDepartmentName}'),
                      Text('Priority: ${report.priorityName}'),
                      Text('Rating: ${report.rating}'),
                      const SizedBox(height: 4),
                      Text(
                        'Description: ${report.descriptionIssues}',
                        style: const TextStyle(color: Colors.black87),
                      ),
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
