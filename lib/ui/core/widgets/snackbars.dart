import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

abstract final class Snackbars {
  static void show(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        width: MediaQuery.sizeOf(context).width * 0.8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: AppColors.getColorFormHex('#1F6B4A'),
            width: 1,
          ),
        ),
        backgroundColor: AppColors.getColorFormHex('#143028'),
        content: Text(
          text,
          style: .new(color: AppColors.textPrimary),
        ),
        showCloseIcon: true,
        elevation: 15,
        closeIconColor: AppColors.textPrimary,
        duration: .new(seconds: 15),
      ),
    );
  }
}
