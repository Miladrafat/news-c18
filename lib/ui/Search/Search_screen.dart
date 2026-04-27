import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../model/articles_response/Article.dart';
import '../artices/widgets/article_item.dart';
import 'All_view_model/AllViewModel.dart';
import 'All_view_model/All_Articel_Items.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController search;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    search=TextEditingController();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    search.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (context) => AllViewModel()..getSources(null),
          child: Consumer<AllViewModel>(
            builder: (context, viewModel, child) {
              if(viewModel.isLoading){
                return Center(child: CircularProgressIndicator(),);
              }
              if(viewModel.errorMessage!=null){
                return  Center(child: Text(viewModel.errorMessage!),);
              }
              List<Article> articles = viewModel.sources??[];
              if(articles.isEmpty){
                return Center(child: Text("No articles found"),);
              }
              return Column(
                children: [
                  SizedBox(height: 20.h,),
                  TextField(
                   keyboardType:TextInputType.name ,
                    maxLength: 20,
                    controller:search ,
                    decoration: InputDecoration(
                      hintText: "Search",hintStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600
                    ),

                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          if (search.text.isEmpty){
                            return;
                          }
                          viewModel.getSources(search.text);
                        },
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(

                          color: Colors.grey,
                          width: 1.5.w,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2.w,
                        ),
                      ),

                    ),

                  ),
                  SizedBox(height: 10.h,),
                  Expanded(
                    child: ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(height: 16.h,),
                        itemBuilder: (context, index) => FadeInLeft(
                            duration: const Duration(milliseconds: 700),
                            delay: Duration(milliseconds:  1000),
                            child: AllArticelItems(article: articles[index],index: index,)),
        
                        itemCount: articles.length
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      )
    );
  }
}
