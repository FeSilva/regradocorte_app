import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 33, 33, 33),
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 100),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Agendamentos',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 25, 25, 25),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.orange,
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: ListView.builder(
        itemCount: 5, // Altere conforme o número desejado de cards
        itemBuilder: (context, index) {
          return CustomCardWidget();
        },
      ),
    );
  }
}

class CustomCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      color: Color.fromARGB(255, 50, 50, 50),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          // Primeira Coluna (md-4)
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 42, 41, 41),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  bottomLeft: Radius.circular(12.0),
                ),
              ),
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Image.asset(
                  'assets/images/logo.jpg',
                  height: 80.0,
                  width: 80.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Segunda Coluna (md-8)
          Expanded(
            flex: 8,
            child: Container(
              color: Color.fromARGB(255, 42, 41, 41),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Linha 1
                  Text(
                    'Linha 1 da Coluna 2',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  // Linha 2
                  Text(
                    'Linha 2 da Coluna 2',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  // Linha 3 com os botões
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          // Lógica para reagendar
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: Size(0, 0),
                        ),
                        child: Text(
                          'Reagendar',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      TextButton(
                        onPressed: () {
                          // Lógica para cancelar
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: Size(0, 0),
                        ),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      TextButton(
                        onPressed: () {
                          // Lógica para confirmar
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: Size(0, 0),
                        ),
                        child: Text(
                          'Confirmar',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


void main() {
  runApp(MaterialApp(
    home: SchedulePage(),
  ));
}
