import 'package:connectivity_plus/connectivity_plus.dart';
  class CheckNetwork {
    final Connectivity connectivity;

    CheckNetwork(this.connectivity);

    Future<bool> isConnected() async {
      var connectivityResult = await connectivity.checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    }

    Future<bool> isConnectedStream() async {
      var connectivityResult = await connectivity.onConnectivityChanged.first;
      return connectivityResult != ConnectivityResult.none;
    }

    Future<bool> isConnectedStreamWithTimeout() async {
      var connectivityResult = await connectivity.onConnectivityChanged.first.timeout(const Duration(seconds: 5), onTimeout: () {
        return [ConnectivityResult.none];
      });
      return connectivityResult != ConnectivityResult.none;
    }

    Future<bool> isConnectedStreamWithTimeoutAndRetry() async {
      var connectivityResult = await connectivity.onConnectivityChanged.first.timeout(const Duration(seconds: 5), onTimeout: () {
        return [ConnectivityResult.none];
      });
      if (connectivityResult == ConnectivityResult.none) {
        return await isConnectedStreamWithTimeout();
      }
      return connectivityResult != ConnectivityResult.none;
    }

    Future<bool> isConnectedStreamWithTimeoutAndRetryAndInterval() async {
      var connectivityResult = await connectivity.onConnectivityChanged.first.timeout(const Duration(seconds: 5), onTimeout: () {
        return [ConnectivityResult.none];
      });
      if (connectivityResult == ConnectivityResult.none) {
        await Future.delayed(const Duration(seconds: 5));
        return await isConnectedStreamWithTimeoutAndRetryAndInterval();
      }
      return connectivityResult != ConnectivityResult.none;
    }
  }