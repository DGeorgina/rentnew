import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rentnew/screens/main_screen.dart';
import 'package:rentnew/service/AuthenticationService.dart';
import 'firebase_options.dart';
import 'package:get_it/get_it.dart';
//GetIt.I.get<AuthenticationService>();
Future<void> main() async {


// Alternatively you could write it if you don't like global variables
  GetIt.I.registerSingleton<AuthenticationService>(AuthenticationService());

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
