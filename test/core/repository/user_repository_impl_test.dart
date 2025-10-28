import 'package:face_app/core/services/client/client_service_impl.dart';
import 'package:face_app/core/services/persistence/persistence_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:face_app/core/models/user.dart';
import 'package:face_app/core/repository/user_repository_impl.dart';
import '../../mock/mock_data.dart';
import 'user_repository_impl_test.mocks.dart'; // gerado por build_runner

@GenerateMocks([ClientServiceImpl, PersistenceServiceImpl])
void main() {
  late MockClientServiceImpl mockClientService;
  late MockPersistenceServiceImpl mockPersistenceService;
  late UserRepositoryImpl userRepository;
  late List<User> testUserList;

  setUp(() {
    mockClientService = MockClientServiceImpl();
    mockPersistenceService = MockPersistenceServiceImpl();
    userRepository = UserRepositoryImpl(
      clientService: mockClientService,
      persistenceService: mockPersistenceService,
    );

    testUserList = [testUser];
  });

  group('UserRepositoryImpl Tests', () {
    // --- fetchNewUser ---
    test(
      'fetchNewUser should return a User when ClientService succeeds',
      () async {
        when(
          mockClientService.fetchRandomUser(),
        ).thenAnswer((_) async => testUser);

        final result = await userRepository.fetchNewUser();

        expect(result, isA<User>());
        expect(result.id, testUser.id);
        verify(mockClientService.fetchRandomUser()).called(1);
        verifyNever(mockPersistenceService.saveUser(any));
        verifyNoMoreInteractions(mockClientService);
      },
    );

    test(
      'fetchNewUser should throw an exception when ClientService fails',
      () async {
        final apiError = Exception('Failed to fetch data');
        when(mockClientService.fetchRandomUser()).thenThrow(apiError);

        expect(
          () async => await userRepository.fetchNewUser(),
          throwsA(isA<Exception>()),
        );
        verify(mockClientService.fetchRandomUser()).called(1);
        verifyNever(mockPersistenceService.saveUser(any));
      },
    );

    // --- fetchNewUserTosave ---
    test('fetchNewUserTosave should fetch user and call saveUser', () async {
      when(
        mockClientService.fetchRandomUser(),
      ).thenAnswer((_) async => testUser);
      when(mockPersistenceService.saveUser(any)).thenAnswer((_) async => {});

      await userRepository.fetchNewUserTosave();

      verifyInOrder([
        mockClientService.fetchRandomUser(),
        mockPersistenceService.saveUser(testUser),
      ]);
      verifyNoMoreInteractions(mockClientService);
    });

    // --- saveUser ---
    test('saveUser should call PersistenceService.saveUser', () async {
      when(mockPersistenceService.saveUser(any)).thenAnswer((_) async => {});

      await userRepository.saveUser(testUser);

      verify(mockPersistenceService.saveUser(testUser)).called(1);
      verifyNever(mockClientService.fetchRandomUser());
    });

    // --- deleteUser ---
    test('deleteUser should call PersistenceService.deleteUser', () async {
      when(mockPersistenceService.deleteUser(any)).thenAnswer((_) async => {});

      await userRepository.deleteUser(testUser);

      verify(mockPersistenceService.deleteUser(testUser)).called(1);
      verifyNever(mockClientService.fetchRandomUser());
    });

    // --- getPersistedUsers ---
    test(
      'getPersistedUsers should return a list of users from PersistenceService',
      () async {
        when(
          mockPersistenceService.getPersistedUsers(),
        ).thenAnswer((_) async => testUserList);

        final result = await userRepository.getPersistedUsers();

        expect(result, isA<List<User>>());
        expect(result.length, 1);
        expect(result.first.id, testUser.id);
        verify(mockPersistenceService.getPersistedUsers()).called(1);
        verifyNever(mockClientService.fetchRandomUser());
      },
    );

    test(
      'getPersistedUsers should return an empty list when PersistenceService returns empty',
      () async {
        when(
          mockPersistenceService.getPersistedUsers(),
        ).thenAnswer((_) async => []);

        final result = await userRepository.getPersistedUsers();

        expect(result, isEmpty);
        verify(mockPersistenceService.getPersistedUsers()).called(1);
        verifyNever(mockClientService.fetchRandomUser());
      },
    );

    // --- isUserPersisted ---
    test(
      'isUserPersisted should return true when PersistenceService returns true',
      () async {
        // NOTE: O método na interface original é Future<bool>
        when(mockPersistenceService.isUserPersisted(any)).thenReturn(true);

        final result = await userRepository.isUserPersisted(testUser);

        expect(result, isTrue);
        verify(mockPersistenceService.isUserPersisted(testUser)).called(1);
        verifyNever(mockClientService.fetchRandomUser());
      },
    );

    test(
      'isUserPersisted should return false when PersistenceService returns false',
      () async {
        when(mockPersistenceService.isUserPersisted(any)).thenReturn(false);

        final result = await userRepository.isUserPersisted(testUser);

        expect(result, isFalse);
        verify(mockPersistenceService.isUserPersisted(testUser)).called(1);
        verifyNever(mockClientService.fetchRandomUser());
      },
    );

    // --- cleanPersistList ---
    test('cleanPersistList should call PersistenceService.clearList', () async {
      when(mockPersistenceService.clearList()).thenAnswer((_) async => {});

      await userRepository.cleanPersistList();

      verify(mockPersistenceService.clearList()).called(1);
      verifyNever(mockClientService.fetchRandomUser());
    });
  });
  test('getUser should throw Exception when ClientService fails', () async {
    when(
      mockClientService.fetchRandomUser(),
    ).thenThrow(Exception('Service failed'));

    expect(
      () async => await userRepository.fetchNewUser(),
      throwsA(isA<Exception>()),
    );
  });

  test('getUser should save fetched user to cache', () async {
    final user = testUser; // mock válido
    when(mockClientService.fetchRandomUser()).thenAnswer((_) async => user);

    await userRepository.fetchNewUserTosave();

    verify(mockPersistenceService.saveUser(user)).called(1);
  });
}
