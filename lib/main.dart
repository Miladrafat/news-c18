import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_c18/core/resources/app_theme.dart';
import 'package:news_c18/core/resources/routes_manager.dart';
import 'package:news_c18/ui/Search/All_view_model/AllViewModel.dart';
import 'package:news_c18/ui/Search/screen/Search_screen.dart';
import 'package:news_c18/ui/home/screen/home_screen.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routes: {
            RoutesManager.homeRouteName:(_)=>HomeScreen(),
            RoutesManager.searchRouteName:(_)=>ChangeNotifierProvider(
              create: (context) => AllViewModel(),
                child: SearchScreen()),
          },
          initialRoute: RoutesManager.homeRouteName,
        );
      },
    );
  }
}


