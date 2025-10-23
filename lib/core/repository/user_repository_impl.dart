import 'package:persona_app/core/models/user.dart';
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
  Future<User> fetchNewUser() async {
    return await _clientService.fetchRandomUser();
  }

  @override
  Future<User> fetchNewUserTosave() async {
    User newUser = await _clientService.fetchRandomUser();
    saveUser(newUser);
    return newUser;
  }

  @override
  Future<void> saveUser(User user) async {
    return _persistenceService.saveUser(user);
  }

  @override
  Future<void> deleteUser(User userDelet) async {
    return _persistenceService.deleteUser(userDelet);
  }

  @override
  Future<List<User>> getPersistedUsers() async {
    return await _persistenceService.getPersistedUsers();
  }

  @override
  Future<bool> isUserPersisted(User user) async {
    return _persistenceService.isUserPersisted(user);
  }

  @override
  Future<void> cleanPersistList() {
    return _persistenceService.clearList();
  }
}
