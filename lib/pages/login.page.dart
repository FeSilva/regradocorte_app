import 'package:flutter/material.dart';
import 'package:regradocorte_app/pages/modules/about.dart';
import 'package:regradocorte_app/pages/preregister.page.dart';
import 'package:regradocorte_app/pages/reset-password.dart';
import 'package:regradocorte_app/pages/home.page.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:regradocorte_app/pages/login/login_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userEmail = prefs.getString('user_email');

  runApp(MyApp(userEmail: userEmail));
}

class MyApp extends StatelessWidget {
  final String? userEmail;

  MyApp({this.userEmail});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ... outras configurações do aplicativo ...
      home: userEmail != null ? HomePage() : LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60, left: 40, right: 40),
        color: Color.fromARGB(255, 25, 25, 25),
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 300,
              height: 300,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 25, 25, 25),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo_app.png',
                      width: 300,
                      height: 300,
                    ),
                  ],
                ),
              ),
            ),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 25, 25, 25),
                prefixIcon: Icon(Icons.mail),
                labelText: 'E-mail',
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: passwordController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 25, 25, 25),
                prefixIcon: Icon(Icons.password),
                labelText: 'Senha',
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Container(
              height: 40,
              alignment: Alignment.centerRight,
              child: TextButton(
                child: Text(
                  "Recuperar senha",
                  textAlign: TextAlign.right,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResetPasswordPage(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 60,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.3, 1],
                  colors: [
                    Colors.orange,
                    Color(0xFFFFBD59),
                  ],
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: SizedBox.expand(
                child: TextButton(
                  child: Text(
                    "Acessar",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    _doLogin(context);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 40,
              child: TextButton(
                child: Text(
                  "Cadastre-se",
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => preRegister(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _doLogin(BuildContext context) async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Obtenha a instância do Firestore
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        QuerySnapshot userSnapshot = await firestore
        .collection('users')
        .where('uuid', isEqualTo: userCredential.user!.uid)
        .get();

        // Verifique se algum documento foi encontrado
        if (userSnapshot.docs.isNotEmpty) {
          // Obtenha o primeiro documento encontrado (presumindo que haja apenas um com o mesmo UUID)
          DocumentSnapshot userDocument = userSnapshot.docs.first;

          // Agora você pode acessar os dados do usuário, por exemplo:
          String userRole = userDocument['role'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
       
          if (userRole == 'shalonAdmin') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AboutMeWidget(ownerShalonId: userCredential.user!.uid),
              ),
            );
          }

          if (userRole == 'customer') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          }

          if (userRole == 'barber') {
            /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeBarberPage(),
              ),
            );*/
          }
          // Salve a informação do usuário logado nas SharedPreferences
       
        } else {
          // Não foram encontradas referências para o usuário
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Usuário sem referências associadas.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login falhou. Verifique suas credenciais.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, preencha os campos corretamente.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
