import 'package:flutter/material.dart';
import 'package:regradocorte_app/pages/register.page.dart';
import 'package:regradocorte_app/pages/register/registerbarber.page.dart';

class preRegister extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 25, 25, 25),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 25, 25, 25),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 100),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.orange,
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                        'assets/images/logo_app.png', // Ajuste o caminho conforme necessário
                        width: 300,
                        height: 300,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterBarberPage()));
                },
                child: Card(
                  color: Color.fromARGB(255, 22, 22, 22),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.category,
                                size: 80.0,
                                color: Colors.orange,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Barbershop Owner',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Subtítulo 1',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                       
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 3.0),
               GestureDetector(
                onTap: () {
                  // Adicione o código para abrir o widget desejado ao clicar no primeiro card
                  // Exemplo: Navigator.push(context, MaterialPageRoute(builder: (context) => OutroWidget()));
                },
                child: Card(
                  color: Color.fromARGB(255, 22, 22, 22),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.category,
                                size: 80.0,
                                color: Colors.orange,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Barbeiro',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Subtítulo 1',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                       
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              GestureDetector(
                onTap: () {
                   Navigator.push(
                    context,      
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(),
                    ),
                  );
                  // Adicione o código para abrir o widget desejado ao clicar no segundo card
                  // Exemplo: Navigator.push(context, MaterialPageRoute(builder: (context) => OutroWidget()));
                },
                child: Card(
                  color: Color.fromARGB(255, 22, 22, 22),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person,
                                size: 80.0,
                                color: Colors.orange,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                              'Cliente',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Subtítulo 1',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.orange,
                              ),
                            ),
                            ],
                          ),
                        ),
                       
                        SizedBox(width: 8.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: preRegister(),
  ));
}
