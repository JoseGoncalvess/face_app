import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:persona_app/core/models/user.dart';
import 'package:persona_app/core/repository/user_repository_impl.dart';
import 'package:persona_app/src/home/home.dart';
import 'package:provider/provider.dart';

abstract class HomeViewModel extends State<Home>
    with SingleTickerProviderStateMixin {
  late final PageController pageController;
  late final Ticker _ticker;
  late final UserRepositoryImpl _userRepository;
  List<User> liveUsers = [];

  User? currentUser;
  bool isLoading = false;
  String? errorMessage;
  // ------------------------------------

  int currentPage = 0;
  Duration _lastTickTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    pageController = PageController();

    _userRepository = context.read<UserRepositoryImpl>();

    _userRepository.getPersistedUsers().then((value) {
      setState(() {
        liveUsers = value;
      });
    });

    _ticker = createTicker(_onTick);
    _setupTicker();
  }

  @override
  void dispose() {
    _ticker.stop();
    _ticker.dispose();
    pageController.dispose();
    super.dispose();
  }

  void _setupTicker() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _ticker.start();
        _onTick(Duration.zero, forceRun: true);
      }
    });
  }

  void _onTick(Duration elapsed, {bool forceRun = false}) async {
    final bool timeHasPassed =
        (elapsed - _lastTickTime > const Duration(seconds: 5));

    if (!timeHasPassed && !forceRun) {
      return;
    }

    _lastTickTime = elapsed;
    if (isLoading) return;

    if (currentPage == 0 && mounted) {
      if (mounted) {
        setState(() {
          isLoading = true;
          errorMessage = null;
        });
      }

      _userRepository.getPersistedUsers().then((value) {
        setState(() {
          liveUsers = value;
        });
      });

      try {
        final User user = await _userRepository.fetchNewUserTosave();
        if (mounted) {
          setState(() {
            currentUser = user;
            isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            errorMessage = e.toString();
            isLoading = false;
          });
        }
      }
    }
  }

  void onPageChanged(int page) {
    if (mounted) {
      setState(() {
        currentPage = page;
      });

      if (currentPage == 0) {
        _onTick(Duration.zero, forceRun: true);
      }
    }
  }

  void onBottomNavTapped(int index) async {
    if (mounted) {
      setState(() {
        currentPage = index;
      });

      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );

      if (currentPage == 0) {
        _userRepository.getPersistedUsers().then((value) {
          setState(() {
            liveUsers = value;
          });
        });
        _onTick(Duration.zero, forceRun: true);
      }
    }
  }
}
