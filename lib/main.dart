import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneymanager/controller/expense/expense_controller.dart';
import 'package:moneymanager/view/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money Manager',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      routes: {
        'home': (context) => const ScreenHome(),
      },
      initialRoute: 'home',
      
    );
  }
}
