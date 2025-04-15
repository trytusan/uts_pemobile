import 'dart:io';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:uts_aplication/models/uts_models.dart';

class DataListService {
  final String baseUrl =
      'https://simobile.singapoly.com/api/trpl/customer-service';
  Future<List<Report>> getAllReports() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Accept': 'application/json'},
    );

    print('Response code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final data = jsonBody['datas'];

      if (data == null) {
        print('⚠️ DATA NULL');
        return [];
      }

      if (data is List) {
        print('✅ DATA LIST: ${data.length} item');
        return data.map((json) => Report.fromJson(json)).toList();
      } else if (data is Map<String, dynamic>) {
        print('✅ DATA OBJECT tunggal');
        return [Report.fromJson(data)];
      } else {
        print('❌ FORMAT DATA TIDAK DIKENALI');
        return [];
      }
    } else {
      throw Exception('Status: ${response.statusCode}');
    }
  }

  // GET report berdasarkan NIM
  Future<List<Report>> fetchReportsByNim(String nim) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$nim'),
      headers: {'Accept': 'application/json'},
    );

    final jsonBody = jsonDecode(response.body);
    final dynamic data = jsonBody['datas'];

    if (data == null) {
      return [];
    }

    if (data is List) {
      return data.map((json) => Report.fromJson(json)).toList();
    } else if (data is Map<String, dynamic>) {
      return [Report.fromJson(data)];
    } else {
      throw Exception('Format data tidak dikenali');
    }
  }

  // GET report berdasarkan NIM dan ID
  Future<Report> fetchReportByNimAndId(String nim, int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$nim/$id'),
      headers: {'Accept': 'application/json'},
    );

    print('🔍 Response Status: ${response.statusCode}');
    print('📦 Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final data = jsonBody['datas'];

      print('🧪 Type of data: ${data.runtimeType}');

      if (data == null) {
        throw Exception("❌ Data tidak ditemukan (null)");
      }

      if (data is Map<String, dynamic>) {
        return Report.fromJson(data);
      } else if (data is List && data.isNotEmpty) {
        return Report.fromJson(data.first);
      } else {
        throw Exception("❌ Format data tidak sesuai: $data");
      }
    } else {
      throw Exception(
        '❌ Failed to fetch by NIM and ID. Status: ${response.statusCode}',
      );
    }
  }

  // POST create report
  Future<Report> createReport({
    required String nim,
    required String titleIssues,
    required String descriptionIssues,
    required int rating,
    required File? imageFile,
    required int idDivisionTarget,
    required int idPriority,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/2355011001'); // ⬅️ pastikan endpoint benar
      final request = http.MultipartRequest('POST', uri);

      // Tambahkan field text
      request.fields['nim'] = nim;
      request.fields['title_issues'] = titleIssues;
      request.fields['description_issues'] = descriptionIssues;
      request.fields['rating'] = rating.toString();
      request.fields['id_division_target'] = idDivisionTarget.toString();
      request.fields['id_priority'] = idPriority.toString();

      // Tambahkan file gambar jika ada
      if (imageFile != null) {
        final stream = http.ByteStream(imageFile.openRead());
        final length = await imageFile.length();

        final multipartFile = http.MultipartFile(
          'image',
          stream,
          length,
          filename: imageFile.path.split('/').last,
          contentType: MediaType('image', 'jpeg'), // Sesuaikan jika perlu
        );

        request.files.add(multipartFile);
      }

      // Kirim request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Report.fromJson(jsonDecode(responseBody)['datas']);
      } else {
        throw Exception(
          '❌ Failed to create report\nStatus: ${response.statusCode}\nBody: $responseBody',
        );
      }
    } catch (e) {
      throw Exception('❌ Error creating report: $e');
    }
  }

  // POST update report
  Future<Report> updateReport({
    required String idCustomerService,
    required String nim,
    required String titleIssues,
    required String descriptionIssues,
    required int rating,
    required File? imageFile,
    required int idDivisionTarget,
    required int idPriority,
  }) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/2355011001/$idCustomerService',
      ); // misalnya PUT ke /customer-service/{id}
      final request = http.MultipartRequest(
        'POST',
        uri,
      ); // ganti ke PUT jika backend mendukung

      // Field teks
      request.fields['nim'] = nim;
      request.fields['title_issues'] = titleIssues;
      request.fields['description_issues'] = descriptionIssues;
      request.fields['rating'] = rating.toString();
      request.fields['id_division_target'] = idDivisionTarget.toString();
      request.fields['id_priority'] = idPriority.toString();

      // File gambar
      if (imageFile != null) {
        final stream = http.ByteStream(imageFile.openRead());
        final length = await imageFile.length();

        final multipartFile = http.MultipartFile(
          'image',
          stream,
          length,
          filename: imageFile.path.split('/').last,
          contentType: MediaType('image', 'jpeg'),
        );

        request.files.add(multipartFile);
      }

      // Kirim request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Report.fromJson(jsonDecode(responseBody)['datas']);
      } else {
        throw Exception(
          '❌ Failed to update report\nStatus: ${response.statusCode}\nBody: $responseBody',
        );
      }
    } catch (e) {
      throw Exception('❌ Error updating report: $e');
    }
  }

  // DELETE report
  Future<void> deleteReport(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/2355011001/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete report');
    }
  }
}
