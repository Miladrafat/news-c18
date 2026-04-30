import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../model/articles_response/Article.dart';
import '../All_view_model/AllViewModel.dart';
import '../widget/All_Articel_Items.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with TickerProviderStateMixin {
  late ScrollController loadController;
  late TextEditingController search;
  late List<AnimationController> _animationControllers = [];

  @override
  void initState() {
    super.initState();
    search = TextEditingController();
    loadController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var provider = Provider.of<AllViewModel>(context, listen: false);
      provider.searchArticles(null);
      loadController.addListener(() {
        if (loadController.position.pixels >=
            loadController.position.maxScrollExtent - 200 &&
            provider.hasMore &&
            !provider.isLoadingMore) {
          provider.loadMore(search.text.isEmpty ? null : search.text);
        }
      });
    });
  }


  @override
  void dispose() {
    search.dispose();
    loadController.dispose();
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: REdgeInsets.symmetric(horizontal: 8.0.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  TextField(
                    keyboardType: TextInputType.name,
                    maxLength: 20,
                    controller: search,
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      prefixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          var viewModel = Provider.of<AllViewModel>(context, listen: false);
                          viewModel.searchArticles(
                              search.text.isEmpty ? null : search.text);
                        },
                      ),
                      suffixIcon: search.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.close, color: Colors.grey[600]),
                              onPressed: () {
                                search.clear();
                              },
                            )
                          : null,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.5.w,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide:
                            BorderSide(color: Colors.blue, width: 2.w),
                      ),
                    ),
                    onChanged: (value) {

                      setState(() {});
                    },
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),

            Expanded(
              child: Consumer<AllViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading && viewModel.sources.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (viewModel.status == "error" && viewModel.errorMessage != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 50, color: Colors.red),
                          SizedBox(height: 16.h),
                          Text(viewModel.errorMessage ?? "An error occurred",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16.sp)),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: () {
                              viewModel.searchArticles(null);
                            },
                            child: Text("Retry"),
                          )
                        ],
                      ),
                    );
                  }

                  List<Article> articles = viewModel.sources;
                  if (articles.isEmpty) {
                    return InkWell(
                      onTap: () {
                        viewModel.searchArticles(null);
                        search.clear();
                      },
                      child: Center(
                        child: Text("No articles found"),
                      ),
                    );
                  }

                  return Stack(
                    children: [
                      Padding(
                        padding: REdgeInsets.symmetric(horizontal: 8.0.w),
                        child: ListView.separated(
                          controller: loadController,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 16.h),
                          itemCount: articles.length +
                              (viewModel.hasMore || viewModel.isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= articles.length) {
                              if (viewModel.hasLoadMoreError) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 80.h),
                                  child: SizedBox.shrink(),
                                );
                              }
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (index >= _animationControllers.length) {
                              final controller = AnimationController(
                                duration: const Duration(milliseconds: 400),
                                vsync: this,
                              );
                              _animationControllers.add(controller);
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted && index < _animationControllers.length) {
                                  Future.delayed(Duration(milliseconds: 50 * index), () {
                                    if (mounted) {
                                      _animationControllers[index].forward();
                                    }
                                  });
                                }
                              });
                            }

                            final animation = Tween<Offset>(
                              begin: const Offset(-1.0, 0.0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: _animationControllers[index],
                              curve: Curves.easeOut,
                            ));

                            return SlideTransition(
                              position: animation,
                              child: AllArticelItems(
                                article: articles[index],
                                index: index,
                              ),
                            );
                          },
                        ),
                      ),
                      if (viewModel.hasLoadMoreError)
                        Positioned(
                          bottom: 20.h,
                          right: 20.w,
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: FloatingActionButton.extended(
                              onPressed: () {
                                viewModel.loadMore(search.text.isEmpty ? null : search.text,);
                              },
                              icon: Icon(Icons.refresh),
                              label: Text("Retry"),
                              backgroundColor: Colors.grey[700],
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
