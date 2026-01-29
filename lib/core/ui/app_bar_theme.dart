

import 'package:flutter/material.dart';
import 'package:hear_o/core/ui/colors.dart';


class MyAppBarTheme extends AppBarTheme {
  MyAppBarTheme({super.key})
      : super(
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    backgroundColor: AppColors.white,
    foregroundColor: AppColors.primary,
  );
}