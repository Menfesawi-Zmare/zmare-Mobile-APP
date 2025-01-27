import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../core/enum/page_type.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this.settings) : super(const CurrentIndexState(PageType.explorer)) {
    on<HomeEvent>((event, emit) {});
    on<CurrentIndexEvent>(_currentIndex);
  }

  final Box<dynamic> settings;

  PageType currentPage = PageType.explorer;

  void _currentIndex(
    CurrentIndexEvent event,
    Emitter<HomeState> emit,
  ) {
    if (currentPage != event.currentPage) {
      currentPage = event.currentPage;
      emit(CurrentIndexState(event.currentPage));
    }
  }

  int getIndexFromPage(PageType currentPage) {
    switch (currentPage) {
      case PageType.explorer:
        return 0;
      case PageType.latest:
        return 1;
      case PageType.popular:
        return 2;
      case PageType.random:
        return 3;
      case PageType.library:
        return 4;
      default:
        return 0;
    }
  }

  PageType getPageFromIndex(int index) {
    switch (index) {
      case 1:
        return PageType.latest;
      case 2:
        return PageType.popular;
      case 3:
        return PageType.random;
      case 4:
        return PageType.library;
      case 0:
      default:
        return PageType.explorer;
    }
  }
}
