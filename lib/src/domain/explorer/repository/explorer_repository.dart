import 'package:dartz/dartz.dart';
import 'package:zmare/src/core/error/error.dart';
import 'package:zmare/src/data/explorer/model/explorer_model.dart';
import 'package:zmare/src/data/production/model/production_list.dart';

abstract class IExplorerRepository {
  Future<Either<Failure, ExplorerModel>> getExplorer();
  Future<Either<Failure, ProductionList>> getAllProduction(int page);
}
