import 'package:flutter/material.dart';
import 'package:uts_aplication/models/petani_models.dart';

class DetailPetani extends StatelessWidget {
  final Petani petani;
  final String baseUrl = 'https://dev.wefgis.com/';

  const DetailPetani({super.key, required this.petani});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color.fromARGB(255, 76, 174, 255);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Petani'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Foto & Nama
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor, width: 3),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blue,
                      backgroundImage: petani.foto.isNotEmpty
                          ? NetworkImage('$baseUrl${petani.foto}')
                          : null,
                      child: petani.foto.isEmpty
                          ? Icon(Icons.person, size: 60, color: primaryColor)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    petani.nama,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            // Card Informasi
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(Icons.credit_card, 'NIK', petani.nik),
                    _buildInfoRow(Icons.home, 'Alamat', petani.alamat),
                    _buildInfoRow(Icons.phone, 'Telepon', petani.telp),
                    _buildInfoRow(Icons.group, 'Kelompok', petani.namaKelompok),
                    _buildInfoRow(Icons.assignment_ind, 'ID Penjual', petani.idPenjual),
                    _buildInfoRow(
                      petani.status == 'Y' ? Icons.check_circle : Icons.cancel,
                      'Status',
                      petani.status == 'Y' ? 'Aktif' : 'Tidak Aktif',
                      iconColor: petani.status == 'Y' ? Colors.green : Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? iconColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: iconColor ?? const Color.fromARGB(255, 8, 8, 8)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 13, color: Colors.blue)),
                const SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : '-',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
