import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_c18/ui/categories/widgets/category_item.dart';

import '../../../core/resources/strings_manager.dart';
import '../../../model/category_model.dart';
import 'package:animate_do/animate_do.dart';

class CategoriesWidget extends StatelessWidget {
  void Function(CategoryModel) onClick;
  CategoriesWidget({required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  REdgeInsets.all(15),
      child: Column(
        children: [
          Text(StringsManager.welcome,style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w500
          ),),
          SizedBox(height: 16.h,),
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) =>FadeInLeft(
                  duration: const Duration(milliseconds: 700),
                  delay: Duration(milliseconds: 1000),
                  child: CategoryItem(
                    onClick:onClick ,
                    category: CategoryModel.categories[index],
                    index: index,
                  ),
                ),
                separatorBuilder: (context, index) => SizedBox(height: 16.h,),
                itemCount: CategoryModel.categories.length
            ),
          )
        ],
      ),
    );
  }
}
