import 'package:flutter/material.dart';
import 'package:face_app/core/utils/const.dart';
import 'package:face_app/src/details/details.dart';

import 'package:face_app/core/models/user.dart';
import 'package:face_app/core/repository/user_repository_impl.dart';
import 'package:face_app/src/routes/arguments/details_arguments.dart';
import 'package:provider/provider.dart';

abstract class DetailsViewModel extends State<Details> {
  late final UserRepositoryImpl _userRepository;

  User? detailsUser;
  bool isLoading = true;
  bool isPersisted = false;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _userRepository = context.read<UserRepositoryImpl>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (detailsUser == null) {
      _loadUserFromArguments();
    }
  }

  void _loadUserFromArguments() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is DetailsArguments) {
      detailsUser = args.user;
      isConnected = args.isConnected;
      print(args.isConnected);
      setState(() {});

      _checkIfPersisted();
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _checkIfPersisted() async {
    if (detailsUser == null) return;

    final result = await _userRepository.isUserPersisted(detailsUser!);

    if (mounted) {
      setState(() {
        isPersisted = result;
        isLoading = false;
      });
    }
  }

  Future<void> handlePersistenceToggle() async {
    if (detailsUser == null) return;

    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      if (isPersisted) {
        await _userRepository.deleteUser(detailsUser!);
        _showFeedback(
          '${detailsUser!.name.first} removido dos salvos.',
          isError: false,
        );
      } else {
        await _userRepository.saveUser(detailsUser!);
        _showFeedback(
          '${detailsUser!.name.first} salvo com sucesso.',
          isError: false,
        );
      }

      if (mounted) {
        setState(() {
          isPersisted = !isPersisted;
          isLoading = false;
        });
      }
    } catch (e) {
      _showFeedback('Erro ao atualizar: $e', isError: true);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showFeedback(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red[700] : primaryColor,
      ),
    );
  }
}
