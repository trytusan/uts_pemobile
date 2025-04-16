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
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text("Report Detail"),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<Report>(
        future: DataListService().fetchReportByNimAndId(nim, int.parse(id)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                '❌ Failed to load:\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Data not found."));
          }

          final report = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  children: [
                    Center(
                      child: Text(
                        'Detail Laporan',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildItem("👤 NIM", report.nim),
                    const Divider(),
                    _buildItem("📝 Judul", report.titleIssues),
                    const Divider(),
                    _buildItem("🏢 Divisi", report.divisionDepartmentName),
                    const Divider(),
                    _buildItem("⚠️ Prioritas", report.priorityName),
                    const Divider(),
                    _buildItem("⭐ Rating", report.rating),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Text("🗒️ Deskripsi:", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(
                      report.descriptionIssues,
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
