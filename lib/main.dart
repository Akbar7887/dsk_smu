
import 'package:dsk_smu/pages/FirstPage.dart';
import 'package:flutter/material.dart';

import 'domain/Constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Widget page;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(bodyText1: TextStyle(fontFamily: Constans.font)),
        backgroundColor: Colors.white,
      ),
      home: FirstPage(),
    );
  }
}
