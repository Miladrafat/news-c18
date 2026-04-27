import 'package:flutter/material.dart';
import 'package:news_c18/core/remote/network/api_manager.dart';

import '../../../model/articles_response/Article.dart';
import '../../../model/articles_response/Articles_response.dart';
import '../../../model/sources_response/Source.dart';

class AllViewModel extends ChangeNotifier{

  List<Article>? sources;
  String? errorMessage;
  bool isLoading = false;
  getSources(String? searchKeyboard)async{
    try{
      sources = null;
      errorMessage = null;
      isLoading = true;
      notifyListeners();
      var response = await ApiManager.getAllArticles(searchKeyboard);
      isLoading = false;
      if(response.status!="error"){
        // success logic data
        sources = response.articles!;
      }else{
        // server error
        errorMessage = response.message;

      }
      notifyListeners();
    }catch(e){
      isLoading = false;
      errorMessage = "No Internet Connection";
      notifyListeners();
    }

  }

}