import 'dart:io';

import 'package:flutter/material.dart';
import 'package:news_c18/core/remote/network/api_manager.dart';
import 'package:news_c18/core/resources/strings_manager.dart';
import 'package:news_c18/model/category_model.dart';
import 'package:news_c18/ui/artices/screen/articles_widget.dart';
import 'package:news_c18/ui/categories/screen/categories_widget.dart';
import 'package:news_c18/ui/home/widgets/home_drawer.dart';

import '../../../core/resources/routes_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? error;
  CategoryModel? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedCategory==null?StringsManager.home:selectedCategory!.title),
        actions: [
          selectedCategory==null?
              SizedBox.shrink():
          IconButton(
            icon: Icon(Icons.search),
            onPressed: ()async {
              try{
                final result = await InternetAddress.lookup('google.com');
                if (result.isNotEmpty) {
                  Navigator.pushReplacementNamed(context, RoutesManager.searchRouteName);
                }
              }
               on SocketException{

                error="No Internet Connection";
                setState(() {

                });

              }
            },
          )
        ],
      ),
      drawer: HomeDrawer(backHome),

      body:error!=null ?  InkWell(
          onTap: () async{
            try{
              final result = await InternetAddress.lookup('google.com');
              if (result.isNotEmpty) {
                Navigator.pushReplacementNamed(context, RoutesManager.searchRouteName);
              }
            }
            on SocketException {
              error="No Internet Connection";

              setState(() {

              });
            }
          },
          child: Center(child: Text(error.toString())))
          : selectedCategory==null ?
           CategoriesWidget(onClick: chooseCategory,)
          :ArticlesWidget(selectedCategory!)

    );
  }

  chooseCategory(CategoryModel newCategory){
    selectedCategory = newCategory;
    setState(() {

    });
  }

  backHome(){
    Navigator.pop(context);
    selectedCategory=null;
    setState(() {

    });
  }
}
