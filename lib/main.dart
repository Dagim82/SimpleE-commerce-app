import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';
import 'cart_provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'storage_service.dart';

const kSeedColor = Color.fromARGB(255, 47, 130, 208);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = StorageService();
  final savedToken = await storage.getToken();
  final savedUsername = await storage.getUsername();
  final savedCart = await storage.loadCart();

  final initialAuth = (savedToken != null && savedUsername != null)
      ? AuthState(token: savedToken, username: savedUsername)
      : const AuthState();

  runApp(
    ProviderScope(
      overrides: [
        authControllerProvider.overrideWith(
          () => AuthController(initialState: initialAuth),
        ),
        cartProvider.overrideWith(
          () => CartController(initialState: CartState(items: savedCart)),
        ),
      ],
      child: MyApp(isLoggedIn: initialAuth.isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kSeedColor),
        appBarTheme: const AppBarTheme(
          backgroundColor: kSeedColor,
          foregroundColor: Colors.white,
        ),
      ),
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
