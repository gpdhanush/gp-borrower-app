import 'dart:ui';

import 'package:finance_gp/app_config/app_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AlertService {
  BuildContext ctx = navigatorKey.currentState!.overlay!.context;

  Future<void> showLoading([String? title, String? successMessage]) async {
    ThemeData theme = Theme.of(ctx);
    final colorScheme = Theme.of(ctx).colorScheme;

    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorType = EasyLoadingIndicatorType.pulse
      ..indicatorColor = colorScheme.primary
      ..progressColor = colorScheme.primary
      ..backgroundColor = Colors.white
      ..textColor = colorScheme.primary
      ..toastPosition = EasyLoadingToastPosition.center
      ..animationStyle = EasyLoadingAnimationStyle.scale
      ..dismissOnTap = false
      ..userInteractions = false
      ..maskType = EasyLoadingMaskType.black
      ..textStyle = theme.textTheme.bodyMedium?.copyWith(
        fontSize: 14,
        color: colorScheme.primary,
        fontWeight: FontWeight.w700,
        fontFamily: 'tamilFont',
      );
    await EasyLoading.show(
      status: title ?? 'Please wait...',
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
  }

  /// Hides the loading indicator and optionally shows a success message
  Future<void> hideLoading([String? successMessage]) async {
    await EasyLoading.dismiss();
  }

  void errorToast(String message) {
    _showSnackBar(
      message,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
    );
  }

  void successToast(String message) {
    _showSnackBar(
      message,
      backgroundColor: Theme.of(ctx).primaryColor,
      textColor: Colors.white,
    );
  }

  void toast(String message) {
    _showSnackBar(
      message,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }

  void _showSnackBar(
    String message, {
    required Color backgroundColor,
    required Color textColor,
    String? actionLabel = "Okey!",
    VoidCallback? actionEvent,
  }) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontFamily: 'tamilFont',
          ),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        duration: const Duration(seconds: 3),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: actionEvent ?? () => _hideSnackBar(),
              )
            : null,
      ),
    );
  }

  void _hideSnackBar() {
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
  }

  Future<bool?> confirmAlert(BuildContext context, String content) {
    ThemeData theme = Theme.of(context);
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            title: Text(
              "CONFIRM",
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
            content: Text(
              content,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: "tamilFont",
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  "NO",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  "YES",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    color: theme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
