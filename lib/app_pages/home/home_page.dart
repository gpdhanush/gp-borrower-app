import 'package:finance_gp/app_config/index.dart';
import 'package:finance_gp/app_utils/alert_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;
  late User user;
  @override
  void initState() {
    super.initState();
    pageTitleLogs("HOME PAGE");
    user = supabase.auth.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              bool? check = await AlertService().confirmAlert(
                context,
                "Do you want logout now?",
              );
              if (check!) {
                try {
                  await supabase.auth.signOut();
                  if (!context.mounted) return;
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    'login',
                    (r) => false,
                  );
                } catch (e) {
                  AlertService().errorToast("Logout Error");
                }
              }
            },
            icon: Icon(Icons.logout_outlined, color: Colors.white),
          ),
        ],
        title: Text(
          "Home",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25.0),
            Center(
              child: Text(
                "Login with ${user.email.toString().toLowerCase()}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "my_borrowers");
                },
                child: Text("My Borrowers"),
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "history");
                },
                child: Text("History"),
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "dropdowns");
                },
                child: Text("Dropdowns"),
              ),
            ),
            SizedBox(height: 16.0),
            Text("Total Borrowers:-", textAlign: TextAlign.left),
          ],
        ),
      ),
    );
  }
}
