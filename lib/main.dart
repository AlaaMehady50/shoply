import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'screens/splash_screen.dart';
import 'auth/login.dart';
import 'auth/register.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/orders_screen.dart';

// Main entry point of the application
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const ShoplyApp(),
    ),
  );
}

// Main application widget
class ShoplyApp extends StatelessWidget {
  const ShoplyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shoply',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/register': (_) => const RegisterScreen(),
        '/auth': (_) => const LoginScreen(),
        '/home': (_) => const HomeWrapper(),
        '/cart': (_) => const CartScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/orders': (_) => const OrdersScreen(),
      },
    );
  }
}

// Wrapper widget for the home screen with drawer navigation
class HomeWrapper extends StatelessWidget {
  const HomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}