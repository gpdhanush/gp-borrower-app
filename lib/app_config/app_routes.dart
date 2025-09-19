import 'package:finance_gp/app_pages/index.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        switch (settings.name) {
          case "splash":
            return const SplashScreen();
          case "login":
            return const LoginPage();
          case "signup":
            return SignUpPage();
          case "home":
            return HomePage();
          case "my_borrowers":
            return BorrowerList();
          case "add_edit_borrower":
            return AddEditBorrowers();
          case "history":
            return HistoryList();
          case "add_edit_history":
            return AddEditHistory();
        }
        return const LoginPage();
      },
    );
  }
}
