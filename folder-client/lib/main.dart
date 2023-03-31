import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:folder/screen/home.dart';
import 'package:intl/date_symbol_data_local.dart';

// ignore: prefer_const_constructors

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: LoginScreen());
    //노인 메인페이지 열려면 LoginScreen
    //보호자 메인페이지 protecthomescreen
  }
}
