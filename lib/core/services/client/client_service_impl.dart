import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:persona_app/core/models/user.dart';
import 'package:persona_app/core/services/client/iclient_service.dart';
import 'package:persona_app/core/utils/const.dart';

class ClientServiceImpl extends IclientService {
  final http.Client _client;

  ClientServiceImpl({required http.Client client}) : _client = client;
  @override
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

  @override
  Future<bool> connectionCheck() async {
    final uri = Uri.parse(baseUrl);

    try {
      final response = await _client.get(uri);
      return response.statusCode == 200 ? true : false;
    } catch (e) {
      throw Exception('Falha na requisição: $e');
    }
  }
}
