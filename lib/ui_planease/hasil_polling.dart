import 'package:flutter/material.dart';

class HasilPollingPage extends StatelessWidget {
  const HasilPollingPage({super.key});

  final List<Map<String, dynamic>> pollingData = const [
    {
      'topik': 'Tema Kegiatan',
      'opsi': [
        {'nama': 'Bakti Sosial', 'jumlah': 30},
        {'nama': 'Piknik', 'jumlah': 20},
        {'nama': 'Workshop', 'jumlah': 10},
      ],
    },
    {
      'topik': 'Desain Kaos',
      'opsi': [
        {'nama': 'Merah', 'jumlah': 15},
        {'nama': 'Hitam', 'jumlah': 25},
        {'nama': 'Putih', 'jumlah': 10},
      ],
    },
  ];

  void _showVotingDetail(BuildContext context, String topik,
      List<Map<String, dynamic>> opsi) {
    final totalSuara =
        opsi.fold<int>(0, (sum, item) => sum + item['jumlah'] as int);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          maxChildSize: 0.8,
          minChildSize: 0.3,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Detail Voting: $topik',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: opsi.length,
                      itemBuilder: (context, index) {
                        final item = opsi[index];
                        final jumlah = item['jumlah'] as int;
                        final persen = totalSuara > 0
                            ? (jumlah / totalSuara * 100)
                            : 0.0;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item['nama']} ($jumlah suara)',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: persen / 100,
                                backgroundColor: Colors.grey[300],
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                        Colors.teal),
                                minHeight: 8,
                              ),
                              const SizedBox(height: 4),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text('${persen.toStringAsFixed(1)}%'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF263238), Color(0xFF455A64)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(24),
            ),
          ),
        ),
        title: const Row(
          children: [
            Icon(Icons.bar_chart_rounded, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Hasil Polling',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: pollingData.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final item = pollingData[index];
            final opsi =
                (item['opsi'] ?? []) as List<Map<String, dynamic>>;
            final totalSuara =
                opsi.fold<int>(0, (sum, el) => sum + el['jumlah'] as int);
            final persentase = totalSuara > 0
                ? (opsi.first['jumlah'] / totalSuara * 100)
                : 0.0;

            Color progressColor;
            if (persentase >= 70) {
              progressColor = Colors.green;
            } else if (persentase >= 40) {
              progressColor = Colors.orange;
            } else {
              progressColor = Colors.red;
            }

            return GestureDetector(
              onTap: () =>
                  _showVotingDetail(context, item['topik'], opsi),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['topik'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF263238),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Suara: $totalSuara",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 10),
                            decoration: BoxDecoration(
                              color: progressColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "${persentase.toStringAsFixed(0)}%",
                              style: TextStyle(
                                color: progressColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: persentase / 100,
                          backgroundColor: Colors.grey[300],
                          valueColor:
                              AlwaysStoppedAnimation<Color>(progressColor),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
