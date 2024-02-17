// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kartal/kartal.dart';
import 'package:ramadan/ui/home/hadith/HadithPageViewModel.dart';
import 'package:ramadan/ui/home/hadith/components/HadithCard.dart';
import 'package:ramadan/ui/home/hadith/components/HadithCategoryFilterButton.dart';
import 'package:ramadan/utils/constants/color_constant.dart';
import 'package:ramadan/utils/constants/string_constant.dart';

class HadithPage extends StatelessWidget {
  late HadithPageViewModel _hadithPageViewModel;
  HadithPage({super.key});

  @override
  Widget build(BuildContext context) {
    _hadithPageViewModel = Get.put(HadithPageViewModel());
    return SafeArea(
      child: Obx(
        () => Scaffold(
            backgroundColor: ColorBackgroundConstant.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: ColorCommonConstant.transparent,
              automaticallyImplyLeading: false,
              title: _Header(
                title: StringHadithConstant.hadithAppBarTitle,
                hadithCategory: _hadithPageViewModel.uniqueCategoryList,
                categoryName: _hadithPageViewModel.categoryName.value,
                onSelected: (String value) async {
                  await _hadithPageViewModel.getHadithsByCategory(value);
                },
              ),
            ),
            body: Obx(
              () => _hadithPageViewModel.isLoading.value
                  ? Padding(
                      padding: context.padding.low,
                      child: ListView.builder(
                        itemCount: _hadithPageViewModel.hadithList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return HadithCard(
                            text: _hadithPageViewModel.hadithList[index].hadith,
                            author: _hadithPageViewModel.hadithList[index].author,
                          );
                        },
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            )),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final List<String> hadithCategory;
  final String categoryName;
  final void Function(String)? onSelected;

  _Header({
    Key? key,
    required this.title,
    required this.hadithCategory,
    required this.categoryName,
    required this.onSelected,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: context.textTheme.bodyMedium?.copyWith(color: ColorTextConstant.black),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              categoryName,
              style: context.textTheme.bodySmall?.copyWith(color: ColorTextConstant.orangeAccent),
            )
          ],
        ),
        Spacer(),
        HadithCategoryFilterButton(
          hadithCategory: hadithCategory,
          onSelected: onSelected,
        )
      ],
    );
  }
}
