import 'dart:async';

import 'package:finance_gp/app_config/app_logs.dart';
import 'package:finance_gp/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  runZonedGuarded(
    () async {
      pageTitleLogs("MAIN FILE");
      WidgetsFlutterBinding.ensureInitialized();

      // Set up system UI
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

      /// *** ==== SUPABASE ====
      await Supabase.initialize(
        url: 'https://fjyhwpdajhbdswmqqkad.supabase.co',
        anonKey:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZqeWh3cGRhamhiZHN3bXFxa2FkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc5ODY1NDMsImV4cCI6MjA3MzU2MjU0M30.ajT2UTVSEb0WVwEg5rsAjXsinqAO4mNeLk1DSdh-4tM',
      );

      /// FLUTTER RUN MAIN
      runApp(const MyApp());
    },
    (error, stack) {
      // FirebaseCrashlytics.instance.recordError(error, stack);
      printContent("FIREBASE ERROR CATCH: ${error.toString()}");
    },
  );
}
