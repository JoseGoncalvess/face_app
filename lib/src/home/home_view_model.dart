import 'package:face_app/core/models/user.dart';
import 'package:face_app/core/repository/user_repository_impl.dart';
import 'package:face_app/core/utils/connectivity_provider.dart';
import 'package:face_app/core/utils/const.dart';
import 'package:face_app/src/home/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:provider/provider.dart';

abstract class HomeViewModel extends State<Home>
    with SingleTickerProviderStateMixin {
  late final PageController pageController;
  late final Ticker _ticker;
  late final UserRepositoryImpl _userRepository;
  late final ConnectivityProvider _connectivityProvider;

  List<User> liveUsers = [];

  User? currentUser;
  bool isLoading = false;
  String? errorMessage;

  bool get isConnected => _connectivityProvider.isConnected;

  int currentPage = 0;
  Duration _lastTickTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    pageController = PageController();

    _userRepository = context.read<UserRepositoryImpl>();
    _connectivityProvider = context.read<ConnectivityProvider>();
    _loadPersistedUsersInitially();
    _ticker = createTicker(_onTick);

    _connectivityProvider.addListener(_handleConnectivityChange);
    _handleConnectivityChange(isInitialCall: true);
  }

  @override
  void dispose() {
    _connectivityProvider.removeListener(_handleConnectivityChange);

    if (_ticker.isActive) {
      _ticker.stop();
    }
    _ticker.dispose();
    pageController.dispose();
    super.dispose();
  }

  Future<void> _loadPersistedUsersInitially() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      if (mounted) {
        _userRepository.getPersistedUsers().then((value) {
          setState(() {
            liveUsers = value;
            isLoading = false;
          });
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erro ao carregar persistidos inicialmente: $e");
      }
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _handleConnectivityChange({bool isInitialCall = false}) {
    if (mounted) {
      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Verifica se o widget ainda está montado ANTES de mostrar SnackBar
        if (!mounted) return;

        if (isConnected) {
          if (!isInitialCall) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(milliseconds: 1200),
                backgroundColor: secundaryColor, // Use sua cor
                content: const Text(
                  'Conexão estabelecida',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.red,
              content: const Text(
                'App sem acesso a internet...',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        }
      });

      if (isConnected) {
        setState(() {
          errorMessage = null;
        });

        if (!_ticker.isActive) {
          if (kDebugMode) {
            print("Conectado. Iniciando Ticker.");
          }
          _ticker.start();
        }

        if (liveUsers.isEmpty || isInitialCall) {
          if (kDebugMode) {
            print(
              "Conectado e lista vazia ou chamada inicial. Buscando dados...",
            );
          }
          fetchDataConditionally(forceRun: true);
        }
      } else {
        if (kDebugMode) {
          print("Desconectado. Parando Ticker.");
        }
        if (_ticker.isActive) {
          _ticker.stop();
        }
        setState(() {
          errorMessage = "Sem conexão com a internet.";
        });
      }
    }
  }

  void _onTick(Duration elapsed) {
    final bool timeHasPassed =
        (elapsed - _lastTickTime >= const Duration(seconds: 5));

    if (!timeHasPassed) return;

    _lastTickTime = elapsed;

    fetchDataConditionally();
  }

  Future<void> fetchDataConditionally({bool forceRun = false}) async {
    if (isLoading || (!forceRun && currentPage != 0)) return;

    if (isConnected && mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      try {
        final User user = await _userRepository.fetchNewUserTosave();

        setState(() {
          currentUser = user;
          isLoading = false;
        });

        _userRepository.getPersistedUsers().then((value) {
          setState(() {
            liveUsers = value;
          });
        });
      } catch (e) {
        if (kDebugMode) {
          print("Erro em fetchDataConditionally: $e");
        }
        setState(() {
          errorMessage =
              "Erro ao buscar novo usuário: ${e.toString().substring(0, 50)}...";
          isLoading = false;
        });
      }
    } else {
      if (kDebugMode) {
        print("Tentativa de busca falhou: Offline.");
      }
      if (mounted) {
        setState(() {
          errorMessage = "Sem conexão com a internet.";
          isLoading = false;
        });
        if (_ticker.isActive) {
          if (kDebugMode) {
            print("Parando Ticker devido a estar offline durante fetch.");
          }
          _ticker.stop();
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
        fetchDataConditionally(forceRun: true);
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
      }
    }
  }
}
