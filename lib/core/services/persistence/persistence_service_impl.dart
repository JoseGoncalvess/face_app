import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:persona_app/core/models/user.dart';
import 'package:persona_app/core/services/persistence/ipersistence_service.dart';
import 'package:persona_app/core/utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistenceServiceImpl extends IpersistenceService {
  final SharedPreferences _prefs;

  PersistenceServiceImpl({required SharedPreferences prefs}) : _prefs = prefs;

  @override
  List<String> getRawUserList() {
    return _prefs.getStringList(kPersistedUsersKey) ?? [];
  }

  @override
  Future<void> saveRawUserList(List<String> userJsonList) {
    return _prefs.setStringList(kPersistedUsersKey, userJsonList);
  }

  @override
  Future<void> saveUser(User user) async {
    if (isUserPersisted(user)) {
      return;
    }

    final List<String> userJsonList = getRawUserList();

    final String newUserJson = jsonEncode(user.toJson());

    userJsonList.add(newUserJson);

    await saveRawUserList(userJsonList);
  }

  @override
  Future<void> deleteUser(User user) async {
    final List<String> userJsonList = getRawUserList();
    final String targetUuid = user.login.uuid;

    List<String> newUserJson = userJsonList.where((userJson) {
      try {
        final userMap = jsonDecode(userJson);
        final Map<String, dynamic> userMapJson = User.fromJson(
          jsonDecode(userMap),
        ).toMap();
        final String uuid = userMapJson['login']?['uuid'] ?? '';
        return uuid != targetUuid;
      } catch (e) {
        if (kDebugMode) {
          print("O erro é o seguinte: $e");
        }
        return false;
      }
    }).toList();

    await saveRawUserList(newUserJson);
  }

  @override
  bool isUserPersisted(User user) {
    final List<String> userJsonList = getRawUserList();
    final String targetUuid = user.login.uuid;

    return userJsonList.any((userJson) {
      try {
        final userMap = jsonDecode(userJson);
        final Map<String, dynamic> userMapJson = User.fromJson(
          jsonDecode(userMap),
        ).toMap();
        final String uuid = userMapJson['login']?['uuid'] ?? '';
        return uuid == targetUuid;
      } catch (e) {
        return false;
      }
    });
  }

  @override
  Future<List<User>> getPersistedUsers() async {
    final List<String> userJsonList = getRawUserList();

    final List<User> users = [];
    for (var userJson in userJsonList) {
      try {
        final userMap = jsonDecode(userJson);
        users.add(User.fromJson(jsonDecode(userMap)));
      } catch (e) {
        if (kDebugMode) {
          print('Erro ao desserializar usuário persistido: $e');
        }
      }
    }
    return users;
  }

  @override
  Future<void> clearList() async {
    _prefs.remove(kPersistedUsersKey);
  }
}
