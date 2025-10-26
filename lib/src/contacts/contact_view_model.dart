import 'package:face_app/src/contacts/contact.dart';
import 'package:face_app/src/routes/arguments/details_arguments.dart';
import 'package:flutter/material.dart';
import 'package:face_app/core/models/user.dart';
import 'package:face_app/core/repository/user_repository_impl.dart';
import 'package:face_app/core/utils/const.dart';
import 'package:provider/provider.dart';

abstract class ContactViewModel extends State<Contact> {
  List<User> users = [];
  late final UserRepositoryImpl _userRepositoryImpl;

  bool isInSelectionMode = false;
  List<User> selectedUsers = [];

  bool isLoading = false;
  bool isConnected = false;

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

  void handleLongPress(User user) {
    if (isInSelectionMode) return;
    if (mounted) {
      setState(() {
        isInSelectionMode = true;
        selectedUsers.add(user);
      });
    }
  }

  void enterEditMode() {
    if (mounted) {
      setState(() {
        isInSelectionMode = true;
      });
    }
  }

  void handleItemTap(User user) {
    if (isInSelectionMode) {
      if (mounted) {
        setState(() {
          if (selectedUsers.contains(user)) {
            selectedUsers.remove(user);
          } else {
            selectedUsers.add(user);
          }
        });
      }
    } else {
      navigateToDetails(user);
    }
  }

  void clearSelection() {
    if (mounted) {
      setState(() {
        isInSelectionMode = false;
        selectedUsers.clear();
      });
    }
  }

  Future<void> deleteSelectedUsers() async {
    if (!mounted) return;

    try {
      final List<Future<void>> deleteFutures = [];
      for (var user in selectedUsers) {
        deleteFutures.add(_userRepositoryImpl.deleteUser(user));
      }

      await Future.wait(deleteFutures);
      setState(() {
        isLoading = !isLoading;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${selectedUsers.length} usuário(s) removido(s).'),
            backgroundColor: primaryColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao deletar usuários: $e')));
      }
    }

    if (mounted) {
      setState(() {
        selectedUsers.clear();
        isInSelectionMode = false;
      });
      await getUsers();
    }
  }

  Future<void> navigateToDetails(User user) async {
    await Navigator.of(context).pushNamed(
      "/details",
      arguments: DetailsArguments(
        user: user,
        isConnected: widget.isconnectState,
      ),
    );

    setState(() {
      isLoading = !isLoading;
    });
    if (mounted) {
      getUsers();
    }
  }
}
