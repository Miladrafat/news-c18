import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_c18/core/remote/network/api_manager.dart';
import 'package:news_c18/model/articles_response/Article.dart';
import 'package:news_c18/model/sources_response/Source.dart';
import 'package:news_c18/ui/artices/widgets/article_item.dart';
import 'package:news_c18/ui/artices/widgets/view_model/articles_list_view_model.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
class ArticlesList extends StatelessWidget {
  final Source source;
  const ArticlesList({super.key,required this.source});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ArticlesListViewModel()..getArticles(source.id??""),
        child: Consumer<ArticlesListViewModel>(
            builder: (context, viewModel, child) {
              if(viewModel.isLoading){
                return Center(child: CircularProgressIndicator(),);
              }
              if(viewModel.errorMessage!=null){
                return InkWell(
                    onTap: () {
                      viewModel.getArticles(source.id??"");
                    },
                    child: Center(child: Text(viewModel.errorMessage!),));
              }
              List<Article> articles = viewModel.articles??[];
              if(articles.isEmpty){
                return Center(child: Text("No articles found"),);
              }
              return ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 16.h,),
                  itemBuilder: (context, index) => FadeInLeft(
                      duration: const Duration(milliseconds: 700),
                      delay: Duration(milliseconds:  1000),
                      child: ArticleItem(article: articles[index],index: index,)),

                  itemCount: articles.length
              );
            },
        ),
    )

      /*FutureBuilder(
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
        },)*/;
  }
}
