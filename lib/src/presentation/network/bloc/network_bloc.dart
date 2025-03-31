// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:zmare/src/app/routes.dart';
import 'package:zmare/src/utils/helper/network_helper.dart';

import '../../../utils/services/firebase/firebase.dart';

part 'network_event.dart';
part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc._() : super(NetworkInitial()) {
    on<NetworkObserve>(_observe);
    on<NetworkNotify>(_notifyStatus);
  }
  static final NetworkBloc _instance = NetworkBloc._();

  factory NetworkBloc() => _instance;

  void _observe(event, emit) {
    NetworkHelper.observeNetwork();
  }

  void _notifyStatus(NetworkNotify event, emit) async {
    if (event.isConnected) {
      await FirebaseServices.init();
      emit(NetworkSuccess());
    } else {
      emit(NetworkFailure());
    }
  }
}
