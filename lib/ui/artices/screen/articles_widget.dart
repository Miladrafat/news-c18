import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_c18/core/remote/network/api_manager.dart';
import 'package:news_c18/core/resources/app_constants.dart';
import 'package:news_c18/model/sources_response/Source.dart';
import 'package:news_c18/model/category_model.dart';
import 'package:news_c18/ui/artices/view_model/sources_view_model.dart';
import 'package:news_c18/ui/artices/widgets/articles_list.dart';
import 'package:provider/provider.dart';

import '../../../core/resources/colors_manager.dart';

class ArticlesWidget extends StatefulWidget {
  CategoryModel selectedCategory;
  ArticlesWidget(this.selectedCategory);

  @override
  State<ArticlesWidget> createState() => _ArticlesWidgetState();
}

class _ArticlesWidgetState extends State<ArticlesWidget> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SourcesViewModel()..getSources(widget.selectedCategory.id),
        child: Consumer<SourcesViewModel>(
          builder: (context, viewModel, child) {
            if(viewModel.isLoading){
              return Center(child: CircularProgressIndicator(),);
            }
            if(viewModel.errorMessage!=null){
              return Center(child: InkWell(
                  onTap: (){
                    viewModel.getSources(widget.selectedCategory.id);
                  },
                  child: Text(viewModel.errorMessage!)),);
            }
            List<Source> sourcesList = viewModel.sources??[];
            return Padding(
              padding: REdgeInsets.all(15),
              child: DefaultTabController(
                length:sourcesList.length ,
                child: Column(
                  spacing: 16.h,
                  children: [
                    TabBar(
                        labelStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorsManager.lightPrimaryColor
                        ),
                        unselectedLabelStyle: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: ColorsManager.lightPrimaryColor
                        ),
                        dividerHeight: 0,
                        tabAlignment: TabAlignment.start,
                        isScrollable: true,
                        tabs: sourcesList.map((source)=>Tab(
                          text:source.name ,
                        )).toList()),
                    Expanded(child: TabBarView(children: sourcesList.map((source) => ArticlesList(source: source,),).toList()))
                  ],
                ),
              ),
            );
          },
        ),
    )

      /*FutureBuilder(
        future: ApiManager.getSources(widget.selectedCategory.id),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          if(snapshot.hasError){
            return Center(child: InkWell(
                onTap: (){
                  setState(() {

                  });
                },
                child: Text("No Internet Connection")),);
          }
          var sourcesResponse = snapshot.data;
          if(sourcesResponse?.status=="error"){
            return Center(child: Text(sourcesResponse?.message??""),);
          }
          List<Source> sourcesList = sourcesResponse?.sources??[];
          return Padding(
            padding: REdgeInsets.all(15),
            child: DefaultTabController(
              length:sourcesList.length ,
              child: Column(
                spacing: 16.h,
                children: [
                  TabBar(
                      labelStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: ColorsManager.lightPrimaryColor
                      ),
                      unselectedLabelStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorsManager.lightPrimaryColor
                      ),
                      dividerHeight: 0,
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      tabs: sourcesList.map((source)=>Tab(
                        text:source.name ,
                      )).toList()),
                  Expanded(child: TabBarView(children: sourcesList.map((source) => ArticlesList(source: source,),).toList()))
                ],
              ),
            ),
          );
        },
    )*/;
  }
}
