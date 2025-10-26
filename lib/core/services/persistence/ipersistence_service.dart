import 'package:face_app/core/models/user.dart';

abstract class IpersistenceService {
  List<String> getRawUserList();
  Future<void> saveRawUserList(List<String> userJsonList);
  Future<void> saveUser(User user);
  Future<void> deleteUser(User user);
  bool isUserPersisted(User user);
  Future<List<User>> getPersistedUsers();
  Future<void> clearList();
}
