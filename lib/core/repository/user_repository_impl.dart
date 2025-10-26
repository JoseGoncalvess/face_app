import 'package:face_app/core/models/user.dart';
import 'package:face_app/core/repository/iuser_repository.dart';
import 'package:face_app/core/services/client/client_service_impl.dart';
import 'package:face_app/core/services/persistence/persistence_service_impl.dart';

class UserRepositoryImpl implements IUserRepository {
  final ClientServiceImpl _clientService;
  final PersistenceServiceImpl _persistenceService;

  UserRepositoryImpl({
    required ClientServiceImpl clientService,
    required PersistenceServiceImpl persistenceService,
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
