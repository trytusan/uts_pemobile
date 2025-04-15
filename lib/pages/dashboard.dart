import 'package:flutter/material.dart';
import 'package:uts_aplication/models/uts_models.dart';
import 'package:uts_aplication/services/api.dart';
import 'package:uts_aplication/pages/editreport.dart';
import 'package:uts_aplication/pages/report.dart';
import 'package:uts_aplication/pages/details.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<List<Report>> _reports;

  @override
  void initState() {
    super.initState();
    _reports = _loadReports();
  }

  Future<List<Report>> _loadReports() async {
    try {
      final data = await DataListService().getAllReports();
      print('✅ Total data report: ${data.length}');
      return data;
    } catch (e) {
      print('❌ Error saat mengambil data: $e');
      rethrow;
    }
  }

  Future<void> _deleteReport(String idCustomerService) async {
    try {
      await DataListService().deleteReport(idCustomerService);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report berhasil dihapus')),
      );
      setState(() {
        _reports = _loadReports(); // refresh setelah hapus
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus report: $e')),
      );
    }
  }

  void _showDetail(String nim) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailByNimPage(nim: nim)),
    );
  }

  void _editReport(Report report) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditReportPage(report: report)),
    );

    if (result == true) {
      setState(() {
        _reports = _loadReports(); // refresh jika update sukses
      });
    }
  }

  void _createReport() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReportFormPage()),
    );

    if (result == true) {
      setState(() {
        _reports = _loadReports(); // refresh jika create sukses
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Report")),
      body: FutureBuilder<List<Report>>(
        future: _reports,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada report'));
          }

          final List<Report> reportList = snapshot.data!;

          return ListView.builder(
            itemCount: reportList.length,
            itemBuilder: (context, index) {
              final report = reportList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text('NIM: ${report.nim}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Judul: ${report.titleIssues}'),
                      Text('Divisi: ${report.divisionDepartmentName}'),
                      Text('Prioritas: ${report.priorityName}'),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _editReport(report);
                      } else if (value == 'delete') {
                        _deleteReport(report.idCustomerService);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Hapus'),
                      ),
                    ],
                  ),
                  onTap: () => _showDetail(report.nim),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createReport,
        tooltip: 'Tambah Report',
        child: const Icon(Icons.add),
      ),
    );
  }
}
