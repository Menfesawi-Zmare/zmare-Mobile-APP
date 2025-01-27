import 'package:dartz/dartz.dart';
import 'package:flutter_music_pro/src/core/api/api.dart';
import 'package:flutter_music_pro/src/core/error/error.dart';
import 'package:flutter_music_pro/src/data/explorer/model/explorer_model.dart';
import 'package:flutter_music_pro/src/data/production/model/production_list.dart';

abstract class IExplorerDataSource {
  Future<Either<Failure,ExplorerModel>> getExplorer();
  Future<Either<Failure,ProductionList>> getAllProduction(int page);
}

class ExplorerDataSource extends IExplorerDataSource {
  ExplorerDataSource(this._client);
  final DioClient _client;
  @override
  Future<Either<Failure,ExplorerModel>> getExplorer() async{
    final response = await _client.getRequest(
      ListAPI.explorer,
      converter: (response) =>
          ExplorerModel.fromJson(response as Map<String, dynamic>),
    );
    return response;
  }
  
  @override
  Future<Either<Failure,ProductionList>> getAllProduction(int page) async{
    final response = await _client.getRequest(
      ListAPI.production,
      queryParameters: {
        'page' : page
      },
      converter: (response) =>
          ProductionList.fromJson(response as Map<String, dynamic>),
    );
    return response;
  }
}
