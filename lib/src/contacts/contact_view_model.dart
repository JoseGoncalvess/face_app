import 'package:flutter/material.dart';
import 'package:persona_app/core/models/user.dart';
import 'package:persona_app/core/repository/user_repository_impl.dart';
import 'package:persona_app/src/contacts/contact.dart';
import 'package:provider/provider.dart';

abstract class ContactViewModel extends State<Contact> {
  List<User> users = [];
  late final UserRepositoryImpl _userRepositoryImpl;

  bool isLoading = false;

  @override
  void initState() {
    _userRepositoryImpl = context.read<UserRepositoryImpl>();
    getUsers();
    super.initState();
  }

  Future<void> getUsers() async {
    _userRepositoryImpl.getPersistedUsers().then((value) {
      setState(() {
        users = value;
        isLoading = !isLoading;
      });
    });
  }

  void deletUserForList(User user) {
    _userRepositoryImpl
        .deleteUser(user)
        .then(
          (value) => setState(() {
            users.removeWhere(
              (element) => element.login.uuid == user.login.uuid,
            );
          }),
        );
  }

  void removeList() {
    _userRepositoryImpl.cleanPersistList();
  }
}
