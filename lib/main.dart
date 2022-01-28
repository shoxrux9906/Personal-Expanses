import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_expenses/ui/home_screen.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ],
  // );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: Colors.yellow,
        primarySwatch: Colors.purple,
        errorColor: Colors.red,
        platform: TargetPlatform.iOS,
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
              title: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
              ),
              button: TextStyle(
                  fontFamily: 'Poppins', fontSize: 18, color: Colors.white)),
        ),
      ),
      home: HomeScreen(),
    ),
  );
}
