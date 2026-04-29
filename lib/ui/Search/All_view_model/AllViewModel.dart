import 'package:flutter/material.dart';
import 'package:news_c18/core/remote/network/api_manager.dart';
import '../../../model/articles_response/Article.dart';


class AllViewModel extends ChangeNotifier {
  List<Article> sources = [];
  String? errorMessage;
  String? status;
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasLoadMoreError = false;
  String? loadMoreErrorMessage;
  bool hasMore = true;
  int page = 1;
  String? lastSearchKeyword; 

  
  Future<void> searchArticles(String? searchKeyword) async {
    if (isLoading) return;
    if (lastSearchKeyword != searchKeyword) {
      sources.clear();
      page = 1;
      lastSearchKeyword = searchKeyword;
    }
    isLoading = true;
    errorMessage = null;
    status = null;
    notifyListeners();

    try {
      var response = await ApiManager.getAllArticles(searchKeyword, page);

      if (response.status == "error") {
        status = response.status;
        errorMessage = response.message ?? "An error occurred";
        isLoading = false;
        hasMore = false;
        notifyListeners();
        return;
      }

      if (response.status == "ok") {
        status = response.status;
        final newArticles = response.articles ?? [];
        sources = newArticles;
        hasMore = newArticles.isNotEmpty;
        page = 2;
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      hasMore = false;

      if (e.toString().contains("Connection Timeout") ||
          e.toString().contains("Connection failed") ||
          e.toString().contains("SocketException") ||
          e.toString().contains("No Internet Connection")) {
        errorMessage = "No Internet Connection";
      } else {
        errorMessage = "Error fetching data";
      }
      notifyListeners();
    }
  }


  Future<void> loadMore(String? searchKeyword) async {
    if (isLoadingMore || !hasMore) return;

    try {
      isLoadingMore = true;
      hasLoadMoreError = false;
      notifyListeners();

      var response = await ApiManager.getAllArticles(searchKeyword, page);

      if (response.status == "error") {
        isLoadingMore = false;
        hasLoadMoreError = true;
        loadMoreErrorMessage = response.message ?? "Failed to load articles";
        notifyListeners();
        return;
      }

      if (response.status == "ok") {
        status = response.status;
        final newArticles = response.articles ?? [];

        if (newArticles.isEmpty) {
          hasMore = false;
        } else {
          sources.addAll(newArticles);
          page++;
        }

        isLoadingMore = false;
        hasLoadMoreError = false;
        notifyListeners();
      }
    } catch (e) {
      isLoadingMore = false;
      hasLoadMoreError = true;

      if (e.toString().contains("No Internet Connection") ||
          e.toString().contains("Connection Timeout") ||
          e.toString().contains("Connection failed") ||
          e.toString().contains("SocketException")) {
        loadMoreErrorMessage = "No Internet Connection";
      } else {
        loadMoreErrorMessage = "Failed to load articles";
      }
      notifyListeners();
    }
  }

}