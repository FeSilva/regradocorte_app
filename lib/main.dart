import 'package:regradocorte_app/pages/login.page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' ;
import 'package:regradocorte_app/pages/perfil_outers.page.dart'; 
import './firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

MaterialColor createMaterialColor(Color color) {
  List<int> strengths = <int>[50, 100, 200, 300, 400, 500, 600, 700, 800, 900];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int strength in strengths) {
    final double weight = 0.5 - (strength / 1000.0);
    final int blendR = ((1 - weight) * r + weight * 255).round();
    final int blendG = ((1 - weight) * g + weight * 255).round();
    final int blendB = ((1 - weight) * b + weight * 255).round();

    swatch[strength] = Color.fromRGBO(blendR, blendG, blendB, 1);
  }

  return MaterialColor(color.value, swatch);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/profileOuters': (context) => ProfileOuters(),
      },
      title: 'Regra do Corte',
      debugShowCheckedModeBanner: false,
    
      theme: ThemeData(
        primarySwatch: createMaterialColor(Color(0xFFFFBD59)),
      ),
      home: LoginPage(),
    );
  }
}
