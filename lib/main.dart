import 'package:flutter/material.dart';
import 'package:makansar_mobile/screens/login.dart';
import 'package:makansar_mobile/screens/menu.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MAKANSAR',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: MaterialColor(
              0xFFe02c2c,
              <int, Color>{
                50: Color(0xFFe02c2c),
                100: Color(0xFFe02c2c),
                200: Color(0xFFe02c2c),
                300: Color(0xFFe02c2c),
                400: Color(0xFFe02c2c),
                500: Color(0xFFe02c2c),
                600: Color(0xFFe02c2c),
                700: Color(0xFFe02c2c),
                800: Color(0xFFe02c2c),
                900: Color(0xFFe02c2c),
              },
            ),
          ).copyWith(
            secondary: Color(0xFFe02c2c),
          ),
          scaffoldBackgroundColor: Color(0xFFF5F3EE),
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );
  }
}