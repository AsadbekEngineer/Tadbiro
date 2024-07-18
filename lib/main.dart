import 'package:exam/firebase_options.dart';
import 'package:exam/views/screens/myEvents/myEventsPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyEvents(),

      // home: Homescreen(),
      // home: MapScreen(),
      // home: Onboarding(),  // 1 chi shuni ko'rsat
    );
  }
}
