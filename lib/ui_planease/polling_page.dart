import 'package:flutter/material.dart';
import 'package:uts_aplication/ui_planease/agenda_polling.dart';
import 'package:uts_aplication/ui_planease/dashboard_planease.dart';
import 'package:uts_aplication/ui_planease/hasil_polling.dart';

void main() {
  runApp(const PollingPage());
}

class PollingPage extends StatelessWidget {
  const PollingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlanEase - Polling',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Sans'),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final int _selectedIndex = 0;

  final List<Map<String, dynamic>> menuItems = const [
    {'color': Color(0xFFF44336), 'label': 'Hasil', 'icon': Icons.bar_chart},
    {'color': Color(0xFFFF9800), 'label': 'Agenda', 'icon': Icons.calendar_month},
  ];

  final List<AnimationController> _controllers = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < menuItems.length; i++) {
      _controllers.add(AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ));
    }
    _playAnimations();
  }

  Future<void> _playAnimations() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      _controllers[i].forward();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onMenuTap(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HasilPollingPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const VotingAgendaPage()),
      );
    }
  }

  Widget _buildRuleCard(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: menuItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
              itemBuilder: (context, index) {
                final item = menuItems[index];
                final animation = CurvedAnimation(
                  parent: _controllers[index],
                  curve: Curves.easeOutBack,
                );

                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(
                    opacity: animation,
                    child: GestureDetector(
                      onTap: () => _onMenuTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: item['color'],
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: item['color'].withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(item['icon'], size: 40, color: Colors.white),
                            const SizedBox(height: 10),
                            Text(
                              item['label'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),

            const Text(
              '📋 Panduan dan Aturan Voting',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263238),
              ),
            ),
            const SizedBox(height: 12),
            _buildRuleCard("• Setiap anggota hanya bisa memberikan 1 suara."),
            _buildRuleCard("• Voting dibuka selama periode yang ditentukan."),
            _buildRuleCard("• Topik dengan suara terbanyak akan diprioritaskan."),
            _buildRuleCard("• Hasil voting bersifat final setelah ditutup."),
            _buildRuleCard("• Pastikan Anda sudah login sebelum memilih."),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF263238), Color(0xFF455A64)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
        ),
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const PlanEaseApp()),
                  (route) => false,
                );
              },
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.how_to_vote, color: Colors.white, size: 26),
            const SizedBox(width: 10),
            const Text(
              'PlanEase - Polling',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: _buildMainContent(),
    );
  }
}
