import 'package:dartz/dartz.dart';
import 'package:flutter_music_pro/src/core/error/error.dart';
import 'package:flutter_music_pro/src/data/explorer/model/explorer_model.dart';
import 'package:flutter_music_pro/src/data/production/model/production_list.dart';

abstract class IExplorerRepository {
  Future<Either<Failure,ExplorerModel>> getExplorer();
  Future<Either<Failure,ProductionList>> getAllProduction(int page);
}
