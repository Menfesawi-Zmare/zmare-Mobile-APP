part of 'explorer_bloc.dart';

abstract class ExplorerState extends Equatable {
  const ExplorerState();

  @override
  List<Object> get props => [];
}

class ExplorerInitial extends ExplorerState {}

class ExplorerLoading extends ExplorerState {}

class ExplorerLoaded extends ExplorerState {
  final ExplorerModel explorerModel;
  const ExplorerLoaded(this.explorerModel);
}

class ProductionLoaded extends ExplorerState {
  final ProductionList productionList;
  const ProductionLoaded(this.productionList);
}

class ExplorerPlaylistLoaded extends ExplorerState {
  final ExplorerPlaylist explorerPlaylist;
  const ExplorerPlaylistLoaded(this.explorerPlaylist);
}

class ExplorerFailedState extends ExplorerState {
  final String message;

  const ExplorerFailedState(this.message);
}
class NoDataFailure extends ExplorerState {}