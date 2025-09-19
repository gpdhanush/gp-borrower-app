import 'package:finance_gp/app_themes/app_custom_themes.dart';
import 'package:flutter/material.dart';

class AppNoDataFound extends StatelessWidget {
  final bool showSecond;

  const AppNoDataFound({super.key, required this.showSecond});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text("No Data Found!", style: AppTextStyles.noDataPrimary),
          ),
          if (showSecond)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Click", style: AppTextStyles.noDataSecondary),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.add_circle_outline_sharp,
                    color: colorScheme.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "to add new records.",
                    style: AppTextStyles.noDataSecondary.copyWith(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
