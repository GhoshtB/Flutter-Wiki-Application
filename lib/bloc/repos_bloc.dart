

import 'package:flutter_app_wiki/db/db_helper.dart';
import 'package:flutter_app_wiki/model/search_results.dart';
import 'package:flutter_app_wiki/repos/Repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';

class Repos_bloc{

  DBHelper database= DBHelper.dbInstance;
  BehaviorSubject<List<Pages>> _repoSubject= BehaviorSubject();
  Repository repository =Repository();

  getDataFromDb(){
    // if(data==null || data.query.pages.length<=0){
      // database.getQuery().then((value) => _repoSubject.sink.add(value.map((e) => SearchResults.fromJson(e)).toList()));
      database.getPages().then((value) =>_repoSubject.sink.add(value) );
    // }

  }

  getReposData(String keys) async{

    SearchResults data =await repository.getSearchResults(keys);

    _repoSubject.sink.add(data.query.pages);

  }
  BehaviorSubject<List<Pages>> get repoSubject=>_repoSubject.stream;
}

final bloc = Repos_bloc();