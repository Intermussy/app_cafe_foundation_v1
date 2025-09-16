// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:app_foundation/constants/enums.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity connectivity;
  StreamSubscription<List<ConnectivityResult>>? connectivityStreamSubscription;

  InternetCubit({required this.connectivity}) : super(InternetLoading()) {
    connectivityStreamSubscription = connectivity.onConnectivityChanged.listen((
      connectivityResult,
    ) {
      final hasWifi = connectivityResult.contains(ConnectivityResult.wifi);
      final hasMobile = connectivityResult.contains(ConnectivityResult.mobile);
      final isOffline =
          connectivityResult.isEmpty ||
          connectivityResult.every((r) => r == ConnectivityResult.none);
      
      if (hasWifi) {
        emitInternetConnected(ConnectionType.wifi);
      } else if (hasMobile) {
        emitInternetConnected(ConnectionType.mobile);
      } else if (isOffline) {
        emitInternetDisconnected();
      }
    });
  }

  void emitInternetConnected(ConnectionType _connectionType) =>
      emit(InternetConnected(connectionType: _connectionType));
  void emitInternetDisconnected() => emit(InternetDisconnected());

  @override
  Future<void> close() {
    // TODO: implement close
    connectivityStreamSubscription?.cancel();
    return super.close();
  }
}
