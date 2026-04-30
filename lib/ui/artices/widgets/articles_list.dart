import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_c18/core/remote/network/api_manager.dart';
import 'package:news_c18/model/articles_response/Article.dart';
import 'package:news_c18/model/sources_response/Source.dart';
import 'package:news_c18/ui/artices/widgets/article_item.dart';
import 'package:news_c18/ui/artices/widgets/view_model/articles_list_view_model.dart';
import 'package:provider/provider.dart';

class ArticlesList extends StatefulWidget {
  final Source source;
  const ArticlesList({super.key,required this.source});

  @override
  State<ArticlesList> createState() => _ArticlesListState();
}

class _ArticlesListState extends State<ArticlesList> with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers = [];

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ArticlesListViewModel()..getArticles(widget.source.id??""),
        child: Consumer<ArticlesListViewModel>(
            builder: (context, viewModel, child) {
              if(viewModel.isLoading){
                return Center(child: CircularProgressIndicator(),);
              }
              if(viewModel.errorMessage!=null){
                return InkWell(
                    onTap: () {
                      viewModel.getArticles(widget.source.id??"");
                    },
                    child: Center(child: Text(viewModel.errorMessage!),));
              }
              List<Article> articles = viewModel.articles??[];
              if(articles.isEmpty){
                return Center(child: Text("No articles found"),);
              }
              return ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 16.h,),
                  itemBuilder: (context, index) {
                    // Create animation controller for each item
                    if (index >= _animationControllers.length) {
                      final controller = AnimationController(
                        duration: const Duration(milliseconds: 400),
                        vsync: this,
                      );
                      _animationControllers.add(controller);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted && index < _animationControllers.length) {
                          Future.delayed(Duration(milliseconds: 50 * index), () {
                            if (mounted) {
                              _animationControllers[index].forward();
                            }
                          });
                        }
                      });
                    }

                    final animation = Tween<Offset>(
                      begin: const Offset(-1.0, 0.0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _animationControllers[index],
                      curve: Curves.easeOut,
                    ));

                    return SlideTransition(
                      position: animation,
                      child: ArticleItem(article: articles[index],index: index,),
                    );
                  },
                  itemCount: articles.length
              );
            },
        ),
    );
  }
}


