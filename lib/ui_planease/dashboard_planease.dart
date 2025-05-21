import 'package:flutter/material.dart';
import 'package:uts_aplication/ui_planease/polling_page.dart'; // Sesuaikan path-nya
import 'package:uts_aplication/ui_planease/notula_page.dart'; // Tambahkan path ini juga

class PlanEaseApp extends StatelessWidget {
  const PlanEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlanEase',
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
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> menuItems = const [
    {'color': Color(0xFFF44336), 'label': 'Polling', 'icon': Icons.how_to_vote},
    {'color': Color(0xFFFF9800), 'label': 'Notula', 'icon': Icons.note_alt},
    {'color': Color(0xFF9C27B0), 'label': 'LPJ', 'icon': Icons.description},
    {'color': Color(0xFF2196F3), 'label': 'Jadwal Rapat', 'icon': Icons.calendar_month},
    {'color': Color(0xFF4CAF50), 'label': 'Kegiatan', 'icon': Icons.event},
    {'color': Color(0xFF00BCD4), 'label': 'Pengumuman', 'icon': Icons.campaign},
    {'color': Color(0xFF607D8B), 'label': 'Dokumentasi', 'icon': Icons.photo_library},
    {'color': Color(0xFF795548), 'label': 'Aduan', 'icon': Icons.report_problem},
  ];

  final List<AnimationController> _controllers = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < menuItems.length; i++) {
      _controllers.add(
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 500),
        ),
      );
    }

    _playAnimations();
  }

  Future<void> _playAnimations() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 80));
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildGridItem(int index) {
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
          onTap: () {
            final label = item['label'];

            if (label == 'Polling') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PollingPage()),
              );
            } else if (label == 'Notula') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotulaPage()),
              );
            } else {
              // Placeholder untuk halaman lain
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Halaman "$label" belum tersedia.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: item['color'],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: item['color'].withOpacity(0.4),
                  blurRadius: 10,
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
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF263238),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
            child: Row(
              children: const [
                Icon(Icons.dashboard_customize, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Text(
                  'PlanEase',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1,
              ),
              itemCount: menuItems.length,
              itemBuilder: (context, index) => _buildGridItem(index),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF263238),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'Kegiatan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}
