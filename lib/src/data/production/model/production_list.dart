import 'package:flutter_music_pro/src/data/pagination/pagination_model.dart';
import 'package:flutter_music_pro/src/data/production/model/production.dart';

class ProductionList {
  List<Production>? production;
  Pagination? pagination;

  ProductionList({this.production, this.pagination});

  ProductionList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      production = <Production>[];
      json['data'].forEach((v) {
        production!.add(Production.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }
}