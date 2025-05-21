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
  final List<Report> _allReports = [];
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 1;
  final int _perPage = 10;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  String? _selectedPriority;
  String? _selectedDivision;

  final List<String> _priorities = ['Low', 'Medium', 'High', 'Critical'];
  final List<String> _divisions = ['Billing', 'Tech', 'OPS', 'Sales'];

  @override
  void initState() {
    super.initState();
    _loadReports();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMoreReports();
      }
    });
  }

  Future<void> _loadReports() async {
    try {
      final data = await DataListService().getReportsByPage(
        page: _currentPage,
        limit: _perPage,
        priority: _selectedPriority,
        division: _selectedDivision,
        query: _searchController.text,
      );

      setState(() {
        _allReports.addAll(data);
        _currentPage++;
        if (data.length < _perPage) _hasMore = false;
      });
    } catch (e) {
      print('❌ Error loading reports: $e');
    }
  }

  Future<void> _loadMoreReports() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    await _loadReports();

    setState(() {
      _isLoadingMore = false;
    });
  }

  void _applyFilter() {
    setState(() {
      _currentPage = 1;
      _allReports.clear();
      _hasMore = true;
    });
    _loadReports();
  }

  Future<void> _deleteReport(String idCustomerService) async {
    try {
      await DataListService().deleteReport(idCustomerService);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report berhasil dihapus')),
      );
      _resetStateAndReload();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus report: $e')),
      );
    }
  }

  void _resetStateAndReload() {
    setState(() {
      _currentPage = 1;
      _hasMore = true;
      _allReports.clear();
      _searchController.clear();
    });
    _loadReports();
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
      _resetStateAndReload();
    }
  }

  void _createReport() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReportFormPage()),
    );

    if (result == true) {
      _resetStateAndReload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Dashboard Report"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedPriority,
                    decoration: const InputDecoration(labelText: "Prioritas"),
                    items: _priorities
                        .map((priority) =>
                            DropdownMenuItem(value: priority, child: Text(priority)))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _selectedPriority = value);
                      _applyFilter();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedDivision,
                    decoration: const InputDecoration(labelText: "Divisi"),
                    items: _divisions
                        .map((division) =>
                            DropdownMenuItem(value: division, child: Text(division)))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _selectedDivision = value);
                      _applyFilter();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              onChanged: (value) => _applyFilter(),
              decoration: InputDecoration(
                hintText: "Search by NIM, Title or Division",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _allReports.isEmpty
                  ? const Center(child: Text('No reports found.'))
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _allReports.length + (_isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _allReports.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final report = _allReports[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: const CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(
                              report.titleIssues,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 6),
                                Text("NIM: ${report.nim}"),
                                Text("Divisi: ${report.divisionDepartmentName}"),
                                Text("Prioritas: ${report.priorityName}"),
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
                    ),
            ),
          ],
        ),
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
