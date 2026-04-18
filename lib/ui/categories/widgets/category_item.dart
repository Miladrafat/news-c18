import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_c18/core/resources/assets_manager.dart';
import 'package:news_c18/model/category_model.dart';

import '../../../core/resources/strings_manager.dart';

class CategoryItem extends StatelessWidget {
  CategoryModel category;
  int index;
  void Function(CategoryModel) onClick;
  CategoryItem({required this.category,required this.index,required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: index.isEven?TextDirection.ltr:TextDirection.rtl,
      child: Container(
        clipBehavior: Clip.antiAlias,
        height: 198.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(24.r)
        ),
        child:  Row(
          children: [
            Expanded(
                child: Image.asset(category.imagePath,height: double.infinity,
                fit: BoxFit.fill,
                )),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                FittedBox(
                  fit:BoxFit.scaleDown,
                  child: Text(category.title,style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontSize: 32.sp
                  ),),
                ),
                 InkWell(
                   onTap: () {
                      onClick(category);
                   },
                   child: Container(
                     padding: REdgeInsetsDirectional.only(
                       start: 16,
                       top: 5,
                       bottom: 5
                     ),
                     decoration: BoxDecoration(
                         color: Colors.white.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(84.r)
                     ),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text(StringsManager.viewAll,style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                             fontWeight: FontWeight.w500
                         ),),
                         SizedBox(width: 10.w,),
                         CircleAvatar(
                           backgroundColor: Theme.of(context).colorScheme.secondary,
                           radius: 27.r,
                           child: SvgPicture.asset(AssetsManager.arrow,
                             matchTextDirection: true,
                             width: 24.w,height: 24.h,),
                         )
                       ],
                     ),
                   ),
                 )
              ],),
            )
          ],
        ),
      ),
    );
  }
}
