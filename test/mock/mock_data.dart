import 'package:face_app/core/models/user.dart';

final testUser = User(
  gender: 'female',
  name: Name(title: 'Ms', first: 'Test', last: 'User'),
  email: 'test.user@example.com',
  login: Login(
    uuid: 'test-uuid-123',
    username: 'testuser',
    password: 'pw',
    salt: 's',
    md5: 'm',
    sha1: 's1',
    sha256: 's2',
  ),
  picture: Picture(
    large: 'large.jpg',
    medium: 'medium.jpg',
    thumbnail: 'thumb.jpg',
  ),
  location: Location(
    street: Street(number: 1, name: 'Test St'),
    city: 'Test City',
    state: 'Test State',
    country: 'Test Country',
    postcode: '12345',
    coordinates: Coordinates(latitude: '1.0', longitude: '2.0'),
    timezone: Timezone(offset: '+0', description: 'UTC'),
  ),
  dob: Dob(date: '1990-01-01T00:00:00.000Z', age: 30),
  registered: Registered(date: '2020-01-01T00:00:00.000Z', age: 1),
  phone: '123-456',
  cell: '789-012',
  id: Id(name: 'TFN', value: '987'),
  nat: 'BR',
);

final testUserJson = {
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
};
