import 'dart:convert';
import 'package:flutter_app_wiki/model/search_results.dart';
import 'package:flutter_app_wiki/util/constants.dart';
import 'package:http/http.dart' as http;
class ApiProvider{

  http.Client client= http.Client();

  Future<SearchResults> getRepositoryData(String keyword) async{

    var response=await http.get(base_url+"${keyword}&gpslimit=10");
    /*page=${firstKey}&per_page=${keyword}*/
    print(base_url+"${keyword}&gpslimit=10");

    var data=json.decode(response.body);
    print(response.body);
    if(response.statusCode==200){
//      print(ReposData.fromJson(data));
     /*  data.map((e) =>
       datas.add(ReposData.fromJson(e)));*/
     return  SearchResults.fromJson(data);
    }else{
      throw Exception('Failed to load post');
    }

  }
}