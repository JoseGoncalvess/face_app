import 'package:persona_app/core/models/person.dart';

abstract class IUserRepository {
  Future<Person> fetchNewUser();

  Future<void> fetchNewUserTosave();

  Future<void> saveUser(Person user);

  Future<void> deleteUser(Person user);

  Future<List<Person>> getPersistedUsers();

  Future<bool> isUserPersisted(Person user);
}
