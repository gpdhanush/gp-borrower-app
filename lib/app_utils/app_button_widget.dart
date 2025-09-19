import 'package:finance_gp/app_themes/app_custom_themes.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final double? width;

  const AppButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.maxFinite,
      child: MaterialButton(
        height: 50,
        elevation: 5,
        onPressed: onPressed,
        color: Colors.indigoAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Text(
          title,
          style: AppTextStyles.textButtonStyle.copyWith(
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
