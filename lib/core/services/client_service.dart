import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:persona_app/core/models/user.dart';
import 'package:persona_app/core/utils/const.dart';

class ClientService {
  final http.Client _client;

  ClientService({required http.Client client}) : _client = client;

  Future<User> fetchRandomUser() async {
    final uri = Uri.parse(baseUrl);

    try {
      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final User apiResponse = User.fromJson(json["results"][0]);
        return apiResponse;
      } else {
        throw Exception('Falha ao carregar usuário: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Falha na requisição: $e');
    }
  }
}
