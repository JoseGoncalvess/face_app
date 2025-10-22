import 'dart:convert';

import 'package:persona_app/core/models/person.dart';
import 'package:persona_app/core/utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistenceService {
  final SharedPreferences _prefs;

  PersistenceService({required SharedPreferences prefs}) : _prefs = prefs;

  List<String> _getRawUserList() {
    return _prefs.getStringList(kPersistedUsersKey) ?? [];
  }

  Future<void> _saveRawUserList(List<String> userJsonList) {
    return _prefs.setStringList(kPersistedUsersKey, userJsonList);
  }

  Future<void> saveUser(Person user) async {
    if (isUserPersisted(user)) {
      return;
    }

    final List<String> userJsonList = _getRawUserList();

    final String newUserJson = jsonEncode(user.toJson());

    userJsonList.add(newUserJson);

    await _saveRawUserList(userJsonList);
  }

  Future<void> deleteUser(Person person) async {
    final List<String> userJsonList = _getRawUserList();
    final String targetUuid = person.login.uuid;

    userJsonList.removeWhere((userJson) {
      try {
        final Map<String, dynamic> userMap = jsonDecode(userJson);
        final String uuid = userMap['login']?['uuid'] ?? '';
        return uuid == targetUuid;
      } catch (e) {
        return true;
      }
    });

    await _saveRawUserList(userJsonList);
  }

  bool isUserPersisted(Person user) {
    final List<String> userJsonList = _getRawUserList();
    final String targetUuid = user.login.uuid;

    return userJsonList.any((userJson) {
      try {
        final Map<String, dynamic> userMap = jsonDecode(userJson);
        final String uuid = userMap['login']?['uuid'] ?? '';
        return uuid == targetUuid;
      } catch (e) {
        return false;
      }
    });
  }

  Future<List<Person>> getPersistedUsers() async {
    final List<String> userJsonList = _getRawUserList();

    final List<Person> users = [];
    for (var userJson in userJsonList) {
      try {
        final userMap = jsonDecode(userJson);
        users.add(Person.fromJson(jsonDecode(userMap)));
      } catch (e) {
        print('Erro ao desserializar usuário persistido: $e');
      }
    }
    return users;
  }
}
