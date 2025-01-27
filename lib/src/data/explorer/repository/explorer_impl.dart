import 'package:dartz/dartz.dart';
import 'package:flutter_music_pro/src/core/error/error.dart';
import 'package:flutter_music_pro/src/data/explorer/data_source/explorer_data_source.dart';
import 'package:flutter_music_pro/src/data/explorer/model/explorer_model.dart';
import 'package:flutter_music_pro/src/data/production/model/production_list.dart';
import 'package:flutter_music_pro/src/domain/explorer/repository/explorer_repository.dart';

class ExplorerRepositoryImpl extends IExplorerRepository {
  IExplorerDataSource iExplorerDataSource;
  ExplorerRepositoryImpl({required this.iExplorerDataSource});

  @override
  Future<Either<Failure,ExplorerModel>> getExplorer() async{
    final response = await iExplorerDataSource.getExplorer();
    return response.fold(
      (failure) => Left(failure),
      (explorerResponse) {
        return Right(explorerResponse);
      },
    );
  }

  @override
  Future<Either<Failure,ProductionList>> getAllProduction(int page) async{
  final response = await iExplorerDataSource.getAllProduction(page);
    return response.fold(
      (failure) => Left(failure),
      (productionResponse) {
        return Right(productionResponse);
      },
    );
  }
}
