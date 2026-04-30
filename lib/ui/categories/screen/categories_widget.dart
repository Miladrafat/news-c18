import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_c18/ui/categories/widgets/category_item.dart';

import '../../../core/resources/strings_manager.dart';
import '../../../model/category_model.dart';

class CategoriesWidget extends StatefulWidget {
  void Function(CategoryModel) onClick;
  CategoriesWidget({required this.onClick});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

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
                itemBuilder: (context, index) {
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
                    child: CategoryItem(
                      onClick: widget.onClick,
                      category: CategoryModel.categories[index],
                      index: index,
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 16.h,),
                itemCount: CategoryModel.categories.length
            ),
          )
        ],
      ),
    );
  }
}
