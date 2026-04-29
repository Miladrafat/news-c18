import 'package:flutter/material.dart';
import 'package:news_c18/model/articles_response/Article.dart';

import '../../../../core/remote/network/api_manager.dart';

class ArticlesListViewModel extends ChangeNotifier{
  List<Article>? articles;
  String? errorMessage;
  bool isLoading = false;
  getArticles(String sourceId)async{
    try{
      articles = null;
      errorMessage = null;
      isLoading = true;
      notifyListeners();
      var response = await ApiManager.getArticles(sourceId);
      isLoading = false;
      if (response.totalResults==0){
        errorMessage="No articles found";
        notifyListeners();
        return;
      }
      if(response.status!="error"){
        // logic success
        articles = response.articles;
      }else{
        // logic server error;
        errorMessage = response.message;
      }
      notifyListeners();
    }catch(e){
      // logic exception error;
      isLoading = false;
      errorMessage = "No Internet Connection";
      notifyListeners();
    }
  }
}