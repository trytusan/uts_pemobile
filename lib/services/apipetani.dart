import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:uts_aplication/models/kelompok_models.dart';
import 'package:uts_aplication/models/petani_models.dart';

class ApiStatic {
  static final String host = 'https://dev.wefgis.com';
  static final String _token = "8|x6bKsHp9STb0uLJsM11GkWhZEYRWPbv0IqlXvFi7";

  static Future<List<Petani>> getPetaniFilter(
    int pageKey,
    String s,
    String selectedChoice, {
    int pageSize = 10,
  }) async {
    try {
      final uri = Uri.parse("$host/api/petani").replace(queryParameters: {
        'page': pageKey.toString(),
        'size': pageSize.toString(), // Sesuaikan jika backend pakai 'limit'
        's': s,
        'publish': selectedChoice,
      });

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $_token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);

        if (json.containsKey('data') && json['data'] is List) {
          final List<dynamic> list = json['data'];
          return list.map((item) => Petani.fromJson(item)).toList();
        } else {
          return [];
        }
      } else {
        print('Error: ${response.statusCode} ${response.reasonPhrase}');
        return [];
      }
    } catch (e, stack) {
      print('Exception in getPetaniFilter: $e');
      print(stack);
      return [];
    }
  }

  static Future<bool> deletePetani(String idPenjual) async {
    try {
      final uri = Uri.parse("$host/api/petani/$idPenjual");
      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $_token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('Gagal hapus data petani, status: ${response.statusCode}');
        return false;
      }
    } catch (e, stack) {
      print('Exception in deletePetani: $e');
      print(stack);
      return false;
    }
  }

  /// Submit form tambah/update petani (manual tanpa model constructor)
  static Future<bool> submitPetaniManual({
    required Map<String, String> data,
    File? foto,
    required bool isEdit,
  }) async {
    try {
      final uri = Uri.parse(isEdit
          ? "$host/api/petani/${data['id_penjual']}"
          : "$host/api/petani");

      final request = http.MultipartRequest("POST", uri);
      request.headers['Authorization'] = "Bearer $_token";

      if (isEdit) {
        request.fields['_method'] = 'PUT';
      }

      request.fields.addAll(data);

      if (foto != null) {
        final stream = http.ByteStream(foto.openRead());
        final length = await foto.length();
        final multipartFile = http.MultipartFile(
          'foto',
          stream,
          length,
          filename: basename(foto.path),
        );
        request.files.add(multipartFile);
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print("Gagal submit data: ${response.statusCode} - $responseBody");
        return false;
      }
    } catch (e, stack) {
      print('Exception in submitPetaniManual: $e');
      print(stack);
      return false;
    }
  }

  static Future<List<Kelompok>> getKelompokTani() async{
    try {
      final response= await http.get(Uri.parse("$host/api/kelompoktani"),
      headers: {
        'Authorization':'Bearer $_token',
      });      
      if (response.statusCode==200) {
        var json=jsonDecode(response.body);
        final parsed=json.cast<Map<String, dynamic>>();
        return parsed.map<Kelompok>((json)=>Kelompok.fromJson(json)).toList();
      } else {
        return [];
      }
      } catch (e) {
        return [];
    }
  }
}
