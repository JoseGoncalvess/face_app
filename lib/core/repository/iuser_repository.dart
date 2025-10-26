import 'package:face_app/core/models/user.dart';

abstract class IUserRepository {
  Future<User> fetchNewUser();

  Future<void> fetchNewUserTosave();

  Future<void> saveUser(User user);

  Future<void> deleteUser(User user);

  Future<List<User>> getPersistedUsers();

  Future<bool> isUserPersisted(User user);
  Future<void> cleanPersistList();
}
