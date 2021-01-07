
import 'package:flutter_app_wiki/api/api_provider.dart';
import 'package:flutter_app_wiki/model/search_results.dart';

class Repository{
  var _apiprovider = ApiProvider();

 Future<SearchResults> getSearchResults(String keyword) async{

    return _apiprovider.getRepositoryData( keyword);
  }

}
