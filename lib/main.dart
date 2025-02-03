import 'package:flutter/material.dart';
import 'ui/theme.dart';
import 'ui/registration_form.dart';
import 'ui/splashscreen.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const MyReactiveForm(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
