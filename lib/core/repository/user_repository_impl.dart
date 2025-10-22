import 'package:persona_app/core/models/person.dart';
import 'package:persona_app/core/repository/iuser_repository.dart';
import 'package:persona_app/core/services/client_service.dart';
import 'package:persona_app/core/services/persistence_service.dart';

class UserRepositoryImpl implements IUserRepository {
  final ClientService _clientService;
  final PersistenceService _persistenceService;

  UserRepositoryImpl({
    required ClientService clientService,
    required PersistenceService persistenceService,
  }) : _clientService = clientService,
       _persistenceService = persistenceService;

  @override
  Future<Person> fetchNewUser() async {
    return await _clientService.fetchRandomUser();
  }

  @override
  Future<void> fetchNewUserTosave() async {
    Person newPerson = await _clientService.fetchRandomUser();
    saveUser(newPerson);
    return;
  }

  @override
  Future<void> saveUser(Person user) async {
    return _persistenceService.saveUser(user);
  }

  @override
  Future<void> deleteUser(Person user) async {
    return _persistenceService.deleteUser(user);
  }

  @override
  Future<List<Person>> getPersistedUsers() async {
    return await _persistenceService.getPersistedUsers();
  }

  @override
  Future<bool> isUserPersisted(Person user) async {
    return _persistenceService.isUserPersisted(user);
  }
}
