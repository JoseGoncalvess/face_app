import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:face_app/core/models/user.dart';
import 'package:face_app/core/services/client/client_service_impl.dart';
import 'package:face_app/core/utils/const.dart';

// Generate mock for http.Client
@GenerateMocks([http.Client])
import 'client_service_impl_test.mocks.dart';

void main() {
  late MockClient mockHttpClient;
  late ClientServiceImpl clientService;

  setUp(() {
    mockHttpClient = MockClient();
    clientService = ClientServiceImpl(client: mockHttpClient);
  });

  final testApiResponse = {
    "results": [
      {
        "gender": "male",
        "name": {"title": "Mr", "first": "John", "last": "Doe"},
        "location": {
          "street": {"number": 123, "name": "Main Street"},
          "city": "New York",
          "state": "NY",
          "country": "USA",
          "postcode": "10001",
          "coordinates": {"latitude": "40.7128", "longitude": "-74.0060"},
          "timezone": {
            "offset": "-05:00",
            "description": "Eastern Time (US & Canada)",
          },
        },
        "email": "john.doe@example.com",
        "login": {
          "uuid": "uuid-1234",
          "username": "johndoe",
          "password": "securepassword",
          "salt": "salt123",
          "md5": "md5hash",
          "sha1": "sha1hash",
          "sha256": "sha256hash",
        },
        "dob": {"date": "1990-05-15T00:00:00Z", "age": 35},
        "registered": {"date": "2020-01-10T00:00:00Z", "age": 5},
        "phone": "555-1234",
        "cell": "555-5678",
        "id": {"name": "SSN", "value": "123-45-6789"},
        "picture": {
          "large": "https://randomuser.me/api/portraits/men/1.jpg",
          "medium": "https://randomuser.me/api/portraits/med/men/1.jpg",
          "thumbnail": "https://randomuser.me/api/portraits/thumb/men/1.jpg",
        },
        "nat": "US",
      },
    ],
  };

  group('ClientServiceImpl Tests', () {
    test(
      'fetchRandomUser should return a User when API responds with status 200',
      () async {
        final uri = Uri.parse(baseUrl);
        when(mockHttpClient.get(uri)).thenAnswer(
          (_) async => http.Response(jsonEncode(testApiResponse), 200),
        );

        final user = await clientService.fetchRandomUser();

        expect(user, isA<User>());
        expect(user.email, equals('john.doe@example.com'));
        expect(user.login.uuid, equals('uuid-1234'));
        verify(mockHttpClient.get(uri)).called(1);
      },
    );

    test(
      'fetchRandomUser should throw an Exception when API returns non-200 status code',
      () async {
        final uri = Uri.parse(baseUrl);
        when(
          mockHttpClient.get(uri),
        ).thenAnswer((_) async => http.Response('Internal Server Error', 500));

        expect(
          () async => await clientService.fetchRandomUser(),
          throwsA(isA<Exception>()),
        );
        verify(mockHttpClient.get(uri)).called(1);
      },
    );

    test(
      'fetchRandomUser should throw an Exception on connection failure',
      () async {
        final uri = Uri.parse(baseUrl);
        when(mockHttpClient.get(uri)).thenThrow(Exception('Connection failed'));

        expect(
          () async => await clientService.fetchRandomUser(),
          throwsA(isA<Exception>()),
        );
        verify(mockHttpClient.get(uri)).called(1);
      },
    );

    test(
      'connectionCheck should return true when API responds with status 200',
      () async {
        final uri = Uri.parse(baseUrl);
        when(
          mockHttpClient.get(uri),
        ).thenAnswer((_) async => http.Response('OK', 200));

        final result = await clientService.connectionCheck();

        expect(result, isTrue);
        verify(mockHttpClient.get(uri)).called(1);
      },
    );

    test(
      'connectionCheck should return false when API responds with non-200 status code',
      () async {
        final uri = Uri.parse(baseUrl);
        when(
          mockHttpClient.get(uri),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        final result = await clientService.connectionCheck();

        expect(result, isFalse);
        verify(mockHttpClient.get(uri)).called(1);
      },
    );

    test(
      'connectionCheck should throw an Exception on network error',
      () async {
        final uri = Uri.parse(baseUrl);
        when(mockHttpClient.get(uri)).thenThrow(Exception('Network error'));

        expect(
          () async => await clientService.connectionCheck(),
          throwsA(isA<Exception>()),
        );
        verify(mockHttpClient.get(uri)).called(1);
      },
    );
  });

  test(
    'fetchRandomUser should throw an Exception when API returns malformed JSON',
    () async {
      final uri = Uri.parse(baseUrl);
      when(
        mockHttpClient.get(uri),
      ).thenAnswer((_) async => http.Response('Invalid JSON', 200));

      expect(
        () async => await clientService.fetchRandomUser(),
        throwsA(isA<Exception>()),
      );
    },
  );
  test(
    'fetchRandomUser should throw an Exception when API returns empty results',
    () async {
      final uri = Uri.parse(baseUrl);
      when(mockHttpClient.get(uri)).thenAnswer(
        (_) async => http.Response(jsonEncode({"results": []}), 200),
      );

      expect(
        () async => await clientService.fetchRandomUser(),
        throwsA(isA<Exception>()),
      );
    },
  );
  test(
    'fetchRandomUser should throw an Exception when request times out',
    () async {
      final uri = Uri.parse(baseUrl);
      when(mockHttpClient.get(uri)).thenAnswer(
        (_) => Future.delayed(
          Duration(seconds: 5),
          () => throw TimeoutException('Request timed out'),
        ),
      );

      expect(
        () async => await clientService.fetchRandomUser(),
        throwsA(isA<Exception>()),
      );
    },
  );
}
