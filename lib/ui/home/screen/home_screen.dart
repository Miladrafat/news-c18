import 'package:flutter/material.dart';
import 'package:news_c18/core/remote/network/api_manager.dart';
import 'package:news_c18/core/resources/strings_manager.dart';
import 'package:news_c18/model/category_model.dart';
import 'package:news_c18/ui/artices/screen/articles_widget.dart';
import 'package:news_c18/ui/categories/screen/categories_widget.dart';
import 'package:news_c18/ui/home/widgets/home_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CategoryModel? selectedCategory;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedCategory==null?StringsManager.home:selectedCategory!.title),
      ),
      drawer: HomeDrawer(backHome),
      body: selectedCategory==null
          ?CategoriesWidget(onClick: chooseCategory,)
          :ArticlesWidget(selectedCategory!),
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
