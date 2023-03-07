import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vfpcl/constants/colors.dart';
import 'package:vfpcl/screens/splash_screen.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  } catch (error) {
    if (kDebugMode) {
      print("Error:: ${error.toString()}");
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VFPCL',
      theme: ThemeData(
          errorColor: errorColor,
          primarySwatch: primarySwatch,
          dividerColor: Colors.transparent,
          appBarTheme: const AppBarTheme(
            foregroundColor: defaultColor,
            backgroundColor: backgroundColor,
            elevation: 0.0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: defaultColor,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          scaffoldBackgroundColor: backgroundColor,
          textTheme: const TextTheme(
            //bodyLarge: ,
            //bodyMedium: ,
            //bodySmall: ,
            bodyText1: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: defaultColor,
            ),
            bodyText2: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: defaultColor,
            ),
            //button: ,
            //caption: ,
            //displayLarge: ,
            //displayMedium: ,
            //displaySmall: ,
            headline1: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: defaultColor,
            ),
            headline2: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: defaultColor,
            ),
            headline3: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: defaultColor,
            ),
            headline4: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: defaultColor,
            ),
            headline5: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: defaultColor,
            ),
            headline6: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: defaultColor,
            ),
            //headlineLarge: ,
            //headlineMedium: ,
            //headlineSmall: ,
            //labelLarge: ,
            //labelMedium: ,
            //labelSmall: ,
            //overline: ,
            //subtitle1: ,
            //subtitle2: ,
            //titleLarge: ,
            //titleMedium: ,
            //titleSmall: ,
          )),
      home: const SplashScreen(),
    );
  }
}
