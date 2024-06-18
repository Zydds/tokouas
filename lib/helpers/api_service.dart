import 'dart:convert';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/model/registrasi.dart';

class ApiService {
  final Api _api = Api();

  Future<Registrasi> registrasi(String nama, String email, String password) async {
    final url = ApiUrl.registrasi;
    final data = jsonEncode({
      'nama': nama,
      'email': email,
      'password': password,
    });

    final response = await _api.post(url, data);
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return Registrasi.fromJson(responseData);
  }
}
