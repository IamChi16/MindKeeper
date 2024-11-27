import "package:flutter/material.dart";
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:reminder_app/main.dart';

//for checking internet connection
abstract class NetworkInfoI {
  Future<bool> isConnected();

  Future<List<ConnectivityResult>> get connectivityResult;

  Stream<List<ConnectivityResult>> get onConnectivityChanged;
}

class NetworkInfo implements NetworkInfoI {
  Connectivity connectivity;

  static final NetworkInfo _networkInfo = NetworkInfo._internal(Connectivity());

  factory NetworkInfo() {
    return _networkInfo;
  }

  NetworkInfo._internal(this.connectivity) {
    connectivity = connectivity;
  }

  //check internet is connected or not
  @override
  Future<bool> isConnected() async {
    final result = await connectivityResult;
    return !result.contains(ConnectivityResult.none);
  }

  @override
  Future<List<ConnectivityResult>> get connectivityResult async {
    return connectivity.checkConnectivity();
  }

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      connectivity.onConnectivityChanged;
}

abstract class Failure {}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}

class ServerException extends Failure {}

class CacheException extends Failure {}

class NetworkException extends Failure {}

class NoInterException implements Exception {
  late String _message;

  NoInternetExcception([String message = 'NoInternetException Occured']) {
    if (globalMessengerKey.currentState != null) {
      globalMessengerKey.currentState!
          .showSnackBar(SnackBar(content: Text(message)));
    }
    _message = message;
  }

  @override
  String toString() {
    return _message;
  }
}