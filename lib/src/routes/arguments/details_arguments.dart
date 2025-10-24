import 'package:persona_app/core/models/user.dart';

class DetailsArguments {
  final User user;
  final bool isConnected;

  DetailsArguments({required this.user, required this.isConnected});
}
