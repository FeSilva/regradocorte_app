import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:regradocorte_app/pages/home.page.dart';
import 'package:dio/dio.dart';
import 'package:regradocorte_app/pages/onboarding.page.dart';
import 'package:regradocorte_app/pages/singUp/singUp_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool _passwordsMatch = true;

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
              controller: nameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Como podemos te chamar ?',
                filled: true,
                fillColor: Color.fromARGB(255, 25, 25, 25),
                prefixIcon: Icon(Icons.supervised_user_circle_sharp),
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
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Qual seu melhor email ?',
                filled: true,
                fillColor: Color.fromARGB(255, 25, 25, 25),
                prefixIcon: Icon(Icons.mail),
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
              keyboardType: TextInputType.visiblePassword,
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
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: confirmPasswordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 25, 25, 25),
                prefixIcon: Icon(Icons.password),
                labelText: 'Confirm Secret',
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
            if (!_passwordsMatch)
              Text(
                'Senhas não coincidem',
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(
              height: 10,
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
                    "Registrar-se",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    _registerUser();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _registerUser() async {
    if (passwordController.text == confirmPasswordController.text) {
      setState(() {
        _passwordsMatch = true;
      });

      try {
        SignUpService()
          .signUpCustomer(emailController.text, passwordController.text, nameController.text);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConcentricAnimationOnboarding()
            ),
          );
        /*final dio = Dio();
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

        final response = await http.post(
          Uri.parse('http://192.168.0.3:8000/api/auth/register'),
          body: {
            'name': nameController.text,
            'email': emailController.text,
            'password': passwordController.text,
            'c_password': confirmPasswordController.text,
          },
        );
        if (response.statusCode == 201) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConcentricAnimationOnboarding()
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao registrar usuário'),
              backgroundColor: Colors.red,
            ),
          );
        }

        print('Response status: ${response.statusCode}');
        print('Response data: ${response.body}');*/
      } catch (error) {
        print('Error during registration: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao registrar usuário'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      setState(() {
        _passwordsMatch = false;
      });
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: RegisterPage(),
  ));
}
