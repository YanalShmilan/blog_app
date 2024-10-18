import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class ConnectionChecker {
  Future<bool> get hasConnection;
}

class NetworkInfo implements ConnectionChecker {
  final InternetConnection dataConnectionChecker;

  NetworkInfo(this.dataConnectionChecker);

  @override
  Future<bool> get hasConnection async =>
      await dataConnectionChecker.hasInternetAccess;
}
