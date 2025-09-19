import 'package:finance_gp/app_themes/app_custom_themes.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> action;

  const AppBarWidget({super.key, required this.title, required this.action});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTextStyles.bodyText.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.indigoAccent,
      automaticallyImplyLeading: true,
      centerTitle: true,
      elevation: 0,
      actions: action,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }
}
