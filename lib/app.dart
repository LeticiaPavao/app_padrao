import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'views/auth/login_page.dart';
import 'views/auth/register_page.dart';
import 'views/auth/reset_password_page.dart';
import 'views/home/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Lojinha',
      locale: const Locale('pt', 'BR'),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/cadastro': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/reset-password': (context) => const ResetPasswordPage(),
      },
    );
  }
}
