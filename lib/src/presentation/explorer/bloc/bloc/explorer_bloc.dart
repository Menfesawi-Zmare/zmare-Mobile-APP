// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zmare/src/core/error/error.dart';
import 'package:zmare/src/data/explorer/model/explorer_model.dart';
import 'package:zmare/src/data/explorer/model/explorer_playlists.dart';
import 'package:zmare/src/data/production/model/production_list.dart';
import 'package:zmare/src/domain/explorer/repository/explorer_repository.dart';

part 'explorer_event.dart';
part 'explorer_state.dart';

class ExplorerBloc extends Bloc<ExplorerEvent, ExplorerState> {
  final IExplorerRepository? iExplorerRepository;
  ExplorerBloc({required this.iExplorerRepository}) : super(ExplorerInitial()) {
    on<GetExplorerEvent>(_loadExplorer);
    on<GetAllProductionEvent>(_loadProduction);
  }

  void _loadExplorer(
      GetExplorerEvent event, Emitter<ExplorerState> emit) async {
    emit(ExplorerLoading());
    final data = await iExplorerRepository!.getExplorer();
    data.fold((l) {
      if (l is ServerFailure) {
        emit(ExplorerFailedState(l.message ?? ""));
      }
    }, (r) {
      if (r.data!.isNotEmpty) {
        emit(ExplorerLoaded(r));
      } else {
        emit(NoDataFailure());
      }
    });
  }

  void _loadProduction(
      GetAllProductionEvent event, Emitter<ExplorerState> emit) async {
    emit(ExplorerLoading());
    final data = await iExplorerRepository!.getAllProduction(event.page);
    data.fold((l) {
      if (l is ServerFailure) {
        emit(ExplorerFailedState(l.message ?? ""));
      }
    }, (r) {
      emit(ProductionLoaded(r));
    });
  }
}
