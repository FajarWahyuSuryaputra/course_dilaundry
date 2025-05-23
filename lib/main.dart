import 'package:course_dilaundry/config/app_session.dart';
import 'package:course_dilaundry/pages/auth/login_page.dart';
import 'package:course_dilaundry/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'config/app_colors.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: Colors.white,
            textButtonTheme: const TextButtonThemeData(
                style: ButtonStyle(
                    textStyle: WidgetStatePropertyAll(
                        TextStyle(color: Colors.white)))),
            colorScheme: ColorScheme.light(
                primary: AppColors.primary,
                secondary: Colors.greenAccent[400]!),
            textTheme: GoogleFonts.latoTextTheme(),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                    backgroundColor:
                        const WidgetStatePropertyAll(AppColors.primary),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                    padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
                    textStyle: const WidgetStatePropertyAll(
                        TextStyle(fontSize: 15, color: Colors.white))))),
        home: FutureBuilder(
          future: AppSession.getUser(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const LoginPage();
            }
            return const Dashboard();
          },
        ));
  }
}
