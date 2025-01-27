import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_music_pro/src/presentation/network/bloc/network_bloc.dart';

class NetworkHelper {
  static void observeNetwork() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
          if (result == ConnectivityResult.none) {
            NetworkBloc().add(NetworkNotify());
          } else {
            NetworkBloc().add(NetworkNotify(isConnected: true));
          }
        } as void Function(List<ConnectivityResult> event)?);
  }
}
