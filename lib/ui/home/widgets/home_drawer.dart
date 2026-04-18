import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_c18/core/resources/strings_manager.dart';

import '../../../core/resources/assets_manager.dart';

class HomeDrawer extends StatelessWidget {
  void Function() backHome;
  HomeDrawer(this.backHome);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Column(
        spacing: 16.h,
        children: [
          Container(
              height: 166.h,
              width: double.infinity,
              color: Colors.white,
              alignment: Alignment.center,
              child: Text(StringsManager.appTitle,style: Theme.of(context).textTheme.headlineMedium,)),
          InkWell(
            onTap: () {
              backHome();
            },
            child: Row(
              children: [
                SvgPicture.asset(AssetsManager.home,height: 24.h,width: 24.w,),
                SizedBox(width: 8.w,),
                Text(StringsManager.goToHome,style: Theme.of(context).textTheme.labelMedium,)
              ],
            ),
          )
        ],
      ),
    );
  }
}
