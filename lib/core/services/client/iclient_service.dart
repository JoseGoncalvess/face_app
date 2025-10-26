import 'package:face_app/core/models/user.dart';

abstract class IclientService {
  Future<User> fetchRandomUser();
  Future<bool> connectionCheck();
}
