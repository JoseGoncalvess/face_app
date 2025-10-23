import 'dart:convert';
import 'dart:developer';

import 'package:persona_app/core/models/user.dart';
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

  Future<void> saveUser(User user) async {
    if (isUserPersisted(user)) {
      return;
    }

    final List<String> userJsonList = _getRawUserList();

    final String newUserJson = jsonEncode(user.toJson());

    userJsonList.add(newUserJson);

    await _saveRawUserList(userJsonList);
  }

  Future<void> deleteUser(User user) async {
    final List<String> userJsonList = _getRawUserList();
    final String targetUuid = user.login.uuid;

    List<String> newUserJson = userJsonList.where((userJson) {
      try {
        final userMap = jsonDecode(userJson);
        log(userMap.toString());
        final Map<String, dynamic> userMapJson = User.fromJson(
          jsonDecode(userMap),
        ).toMap();
        final String uuid = userMapJson['login']?['uuid'] ?? '';
        return uuid != targetUuid;
      } catch (e) {
        log(e.toString());
        return false;
      }
    }).toList();

    await _saveRawUserList(newUserJson);
  }

  bool isUserPersisted(User user) {
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

  Future<List<User>> getPersistedUsers() async {
    final List<String> userJsonList = _getRawUserList();

    final List<User> users = [];
    for (var userJson in userJsonList) {
      try {
        final userMap = jsonDecode(userJson);
        users.add(User.fromJson(jsonDecode(userMap)));
      } catch (e) {
        print('Erro ao desserializar usuário persistido: $e');
      }
    }
    return users;
  }

  Future<void> clearList() async {
    _prefs.remove(kPersistedUsersKey);
  }
}
