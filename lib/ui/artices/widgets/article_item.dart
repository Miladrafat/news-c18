import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/resources/colors_manager.dart';
import '../../../model/articles_response/Article.dart';

class ArticleItem extends StatelessWidget {
  final Article article;

  const ArticleItem({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: REdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorsManager.lightPrimaryColor),
      ),
      child: Column(
        spacing: 10.h,
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(8.r),
            child: CachedNetworkImage(
              imageUrl: article.urlToImage ?? "",
              height: 220.h,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  Center(child: Icon(Icons.error, size: 40.sp)),
            ),
          ),
          Text(
            article.title ?? "",
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontSize: 16.sp),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  "By : ${article.author ?? ""}",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Text(
                timeago.format(DateTime.parse(article.publishedAt ?? "")),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }


}
