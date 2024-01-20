import 'package:flutter/material.dart';
import 'package:regradocorte_app/pages/preregister.page.dart';
import 'package:regradocorte_app/pages/reset-password.dart';
import 'package:regradocorte_app/pages/home.page.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                labelText: 'Secret',
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
                  "Recuperar token",
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
                    _login(context); // Pass the context to the _login function
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

  void _login(BuildContext context) async {
    try {
      final dio = Dio();
      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          print('Request: ${options.method} ${options.uri}');
          print('Request data: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('Response: ${response.statusCode}');
          print('Response data: ${response.data}');
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          print('Error: ${e.message}');
          return handler.next(e);
        },
      ));

      final response = await dio.post(
        'http://192.168.41.150:8000/api/auth/login',
        data: {
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final accessToken = response.data['accessToken'];

        // Armazene o token de acesso usando shared_preferences.
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('accessToken', accessToken);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Desculpe mas suas credenciais estão erradas.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      print('Error during registration: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Desculpe mas suas credenciais estão erradas.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
