part of 'explorer_bloc.dart';

abstract class ExplorerEvent extends Equatable {
  const ExplorerEvent();

  @override
  List<Object> get props => [];
}
class GetExplorerEvent extends ExplorerEvent {}
class GetAllProductionEvent extends ExplorerEvent {
  final int page;
  const GetAllProductionEvent(this.page);
}
class GetExplorerPlaylistEvent extends ExplorerEvent {
  final int page;
  const GetExplorerPlaylistEvent(this.page);
}