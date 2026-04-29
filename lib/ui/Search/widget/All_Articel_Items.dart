import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import '../../../core/resources/colors_manager.dart';
import '../../../model/articles_response/Article.dart';

class AllArticelItems extends StatelessWidget {
  final Article article;
  final int index;

  const AllArticelItems({super.key, required this.article,required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:  () {
        showMyBottomSheet(context);
      },
      child: Container(
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
      ),
    );
  }
  void showMyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: REdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: ColorsManager.lightPrimaryColor),
          ),
          child: Column(
            mainAxisSize: .min,
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
              Text(
                article.description ?? "",
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(fontSize: 16.sp),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    openUrl(article.url);



                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    elevation: 2,
                    padding: REdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text("View Full Articel",style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary
                  ),),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  Future<void> openUrl(String? URL) async {
    final Uri url = Uri.parse(URL??"https://www.google.com/");
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

}
