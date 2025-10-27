import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:face_app/core/utils/enum/connectivity_status.dart';
import 'package:flutter/foundation.dart';

class ConnectivityProvider extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  ConnectivityStatus _status = ConnectivityStatus.checking;
  ConnectivityStatus get status => _status;

  bool get isConnected =>
      _status == ConnectivityStatus.wifi ||
      _status == ConnectivityStatus.mobile;

  ConnectivityProvider() {
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  Future<void> _initConnectivity() async {
    List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao verificar conectividade inicial: $e');
      }
      _status = ConnectivityStatus.none;
      notifyListeners();
      return;
    }
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.wifi)) {
      _status = ConnectivityStatus.wifi;
    } else if (results.contains(ConnectivityResult.mobile)) {
      _status = ConnectivityStatus.mobile;
    } else if (results.contains(ConnectivityResult.none)) {
      _status = ConnectivityStatus.none;
    } else {
      _status = ConnectivityStatus.wifi;
    }
    if (kDebugMode) {
      print('Status da Conectividade: $_status');
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
