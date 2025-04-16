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
  Future<List<Report>>? _reportsFuture;
  List<Report> _allReports = [];
  List<Report> _filteredReports = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _reportsFuture = _loadReports();
  }

  // Fungsi untuk memastikan hanya satu report per NIM
  List<Report> _uniqueByNim(List<Report> reports) {
    final seenNims = <String>{};
    return reports.where((report) {
      final isNew = !seenNims.contains(report.nim);
      seenNims.add(report.nim);
      return isNew;
    }).toList();
  }

  Future<List<Report>> _loadReports() async {
    try {
      final data = await DataListService().getAllReports();
      final uniqueData = _uniqueByNim(data);
      setState(() {
        _allReports = uniqueData;
        _filteredReports = uniqueData;
      });
      return uniqueData;
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  void _filterReports(String query) {
    final lowerQuery = query.toLowerCase();
    final filtered = _allReports.where((report) {
      return report.nim.toLowerCase().contains(lowerQuery) ||
          report.titleIssues.toLowerCase().contains(lowerQuery) ||
          report.divisionDepartmentName.toLowerCase().contains(lowerQuery);
    }).toList();

    setState(() {
      _filteredReports = _uniqueByNim(filtered);
    });
  }

  Future<void> _deleteReport(String idCustomerService) async {
    try {
      await DataListService().deleteReport(idCustomerService);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report berhasil dihapus')),
      );
      final updatedReports = await _loadReports();
      setState(() {
        _searchController.clear();
        _allReports = updatedReports;
        _filteredReports = updatedReports;
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
      final updatedReports = await _loadReports();
      setState(() {
        _searchController.clear();
        _allReports = updatedReports;
        _filteredReports = updatedReports;
      });
    }
  }

  void _createReport() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReportFormPage()),
    );

    if (result == true) {
      final updatedReports = await _loadReports();
      setState(() {
        _searchController.clear();
        _allReports = updatedReports;
        _filteredReports = updatedReports;
      });
    }
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
            title: const Text("Dashboard Report"),
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      body: _reportsFuture == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Report>>(
              future: _reportsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Gagal memuat data: ${snapshot.error}'));
                }

                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        onChanged: _filterReports,
                        decoration: InputDecoration(
                          hintText: "Search by NIM, Title or Division",
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: _filteredReports.isEmpty
                            ? const Center(child: Text('No reports found.'))
                            : ListView.builder(
                                itemCount: _filteredReports.length,
                                itemBuilder: (context, index) {
                                  final report = _filteredReports[index];
                                  return Card(
                                    elevation: 4,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.all(16),
                                      leading: const CircleAvatar(
                                        backgroundColor: Colors.blueAccent,
                                        child: Icon(Icons.person,
                                            color: Colors.white),
                                      ),
                                      title: Text(
                                        report.titleIssues,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 6),
                                          Text("NIM: ${report.nim}"),
                                          Text(
                                              "Divisi: ${report.divisionDepartmentName}"),
                                          Text(
                                              "Prioritas: ${report.priorityName}"),
                                        ],
                                      ),
                                      trailing: PopupMenuButton<String>(
                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            _editReport(report);
                                          } else if (value == 'delete') {
                                            _deleteReport(
                                                report.idCustomerService);
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
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createReport,
        icon: const Icon(Icons.add),
        label: const Text("Tambah Report"),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
