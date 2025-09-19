import 'package:finance_gp/app_config/app_images.dart';
import 'package:finance_gp/app_config/app_logs.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    pageTitleLogs("Spalsh Screen");
    redirectionPage();
  }

  Future<void> redirectionPage() async {
    final supabase = Supabase.instance.client;
    Future.delayed(Duration(seconds: 3), () {
      if (!mounted) return;
      if (supabase.auth.currentUser != null) {
        printContent("USER IS AVAIBLE");
        Navigator.pushNamedAndRemoveUntil(context, 'home', (r) => false);
      } else {
        printContent("USER IS NOT AVAIBLE");
        Navigator.pushNamedAndRemoveUntil(context, 'login', (r) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          AppImages.appLogo,
          height: 150,
          width: 150,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
