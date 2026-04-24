import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_c18/core/remote/network/api_manager.dart';
import 'package:news_c18/model/articles_response/Article.dart';
import 'package:news_c18/model/sources_response/Source.dart';
import 'package:news_c18/ui/artices/widgets/article_item.dart';

class ArticlesList extends StatelessWidget {
  final Source source;
  const ArticlesList({super.key,required this.source});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ApiManager.getArticles(source.id??""),
      builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()),);
          }
          var response = snapshot.data;
          if(response?.status == "error"){
            return Center(child: Text(response?.message??""),);
          }
          List<Article> articles = response?.articles??[];
          if(articles.isEmpty){
            return Center(child: Text("No articles found"),);
          }
          return ListView.separated(
              itemBuilder: (context, index) => ArticleItem(article: articles[index],),
              separatorBuilder: (context, index) => SizedBox(height: 16.h,),
              itemCount: articles.length
          );
        },);
  }
}
