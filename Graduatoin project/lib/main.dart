import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:gp_2/ChatBot/const.dart';
import 'package:gp_2/firebase_options.dart';
import 'package:provider/provider.dart';

import 'Screens/auth-ui/splash-screen.dart';
import 'Screens/setting/theamProvider.dart';

void main() async {
  //Activate gemini pakage
  Gemini.init(apiKey: GEMINI_API_KEY); //From const file
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => Themeprovider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Themeprovider>(
      builder: (context, themeProvider, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false, // Hides the debug banner
          title: 'Flutter Demo',
          theme: themeProvider.themeData,
          home: const SplashScreen(),
        );
      },
    );
  }
}
