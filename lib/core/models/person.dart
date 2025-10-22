import 'dart:convert';

class Person {
  final String gender;
  final Name name;
  final Location location;
  final String email;
  final Login login;
  final Dob dob;
  final Registered registered;
  final String phone;
  final String cell;
  final Id id;
  final Picture picture;
  final String nat;

  Person({
    required this.gender,
    required this.name,
    required this.location,
    required this.email,
    required this.login,
    required this.dob,
    required this.registered,
    required this.phone,
    required this.cell,
    required this.id,
    required this.picture,
    required this.nat,
  });

  String get fullName => '${name.title} ${name.first} ${name.last}';

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      gender: json['gender'] ?? '',
      name: Name.fromJson(json['name']),
      location: Location.fromJson(json['location']),
      email: json['email'] ?? '',
      login: Login.fromJson(json['login']),
      dob: Dob.fromJson(json['dob']),
      registered: Registered.fromJson(json['registered']),
      phone: json['phone'] ?? '',
      cell: json['cell'] ?? '',
      id: Id.fromJson(json['id']),
      picture: Picture.fromJson(json['picture']),
      nat: json['nat'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'gender': gender,
      'name': name.toMap(),
      'location': location.toMap(),
      'email': email,
      'login': login.toMap(),
      'dob': dob.toMap(),
      'registered': registered.toMap(),
      'phone': phone,
      'cell': cell,
      'id': id.toMap(),
      'picture': picture.toMap(),
      'nat': nat,
    };
  }

  String toJson() => json.encode(toMap());
}

class Name {
  final String title;
  final String first;
  final String last;

  Name({required this.title, required this.first, required this.last});

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      title: json['title'] ?? '',
      first: json['first'] ?? '',
      last: json['last'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'title': title, 'first': first, 'last': last};
  }

  String toJson() => json.encode(toMap());
}

class Location {
  final Street street;
  final String city;
  final String state;
  final String country;
  final String postcode;
  final Coordinates coordinates;
  final Timezone timezone;

  Location({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
    required this.coordinates,
    required this.timezone,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      street: Street.fromJson(json['street']),
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',

      postcode: json['postcode']?.toString() ?? '',
      coordinates: Coordinates.fromJson(json['coordinates']),
      timezone: Timezone.fromJson(json['timezone']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'street': street.toMap(),
      'city': city,
      'state': state,
      'country': country,
      'postcode': postcode,
      'coordinates': coordinates.toMap(),
      'timezone': timezone.toMap(),
    };
  }

  String toJson() => json.encode(toMap());
}

class Street {
  final int number;
  final String name;

  Street({required this.number, required this.name});

  factory Street.fromJson(Map<String, dynamic> json) {
    return Street(number: json['number'] ?? 0, name: json['name'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'number': number, 'name': name};
  }

  factory Street.fromMap(Map<String, dynamic> map) {
    return Street(number: map['number'] as int, name: map['name'] as String);
  }

  String toJson() => json.encode(toMap());
}

class Coordinates {
  final String latitude;
  final String longitude;

  Coordinates({required this.latitude, required this.longitude});

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'latitude': latitude, 'longitude': longitude};
  }

  String toJson() => json.encode(toMap());
}

class Timezone {
  final String offset;
  final String description;

  Timezone({required this.offset, required this.description});

  factory Timezone.fromJson(Map<String, dynamic> json) {
    return Timezone(
      offset: json['offset'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'offset': offset, 'description': description};
  }

  String toJson() => json.encode(toMap());
}

class Login {
  final String uuid;
  final String username;
  final String password;
  final String salt;
  final String md5;
  final String sha1;
  final String sha256;

  Login({
    required this.uuid,
    required this.username,
    required this.password,
    required this.salt,
    required this.md5,
    required this.sha1,
    required this.sha256,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      uuid: json['uuid'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      salt: json['salt'] ?? '',
      md5: json['md5'] ?? '',
      sha1: json['sha1'] ?? '',
      sha256: json['sha256'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'username': username,
      'password': password,
      'salt': salt,
      'md5': md5,
      'sha1': sha1,
      'sha256': sha256,
    };
  }

  String toJson() => json.encode(toMap());
}

class Dob {
  final String date;
  final int age;

  Dob({required this.date, required this.age});

  factory Dob.fromJson(Map<String, dynamic> json) {
    return Dob(date: json['date'] ?? '', age: json['age'] ?? 0);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'date': date, 'age': age};
  }

  String toJson() => json.encode(toMap());
}

class Registered {
  final String date;
  final int age;

  Registered({required this.date, required this.age});

  factory Registered.fromJson(Map<String, dynamic> json) {
    return Registered(date: json['date'] ?? '', age: json['age'] ?? 0);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'date': date, 'age': age};
  }

  String toJson() => json.encode(toMap());
}

class Id {
  final String name;
  final String value;

  Id({required this.name, required this.value});

  factory Id.fromJson(Map<String, dynamic> json) {
    return Id(name: json['name'] ?? '', value: json['value'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'name': name, 'value': value};
  }

  String toJson() => json.encode(toMap());
}

class Picture {
  final String large;
  final String medium;
  final String thumbnail;

  Picture({required this.large, required this.medium, required this.thumbnail});

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      large: json['large'] ?? '',
      medium: json['medium'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'large': large,
      'medium': medium,
      'thumbnail': thumbnail,
    };
  }

  String toJson() => json.encode(toMap());
}

class Info {
  final String seed;
  final int results;
  final int page;
  final String version;

  Info({
    required this.seed,
    required this.results,
    required this.page,
    required this.version,
  });

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      seed: json['seed'] ?? '',
      results: json['results'] ?? 0,
      page: json['page'] ?? 0,
      version: json['version'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'seed': seed,
      'results': results,
      'page': page,
      'version': version,
    };
  }

  String toJson() => json.encode(toMap());
}
