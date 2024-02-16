import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:regradocorte_app/pages/home.page.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;


class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late Future<void> scheduleFuture;

  @override
  void initState() {
    super.initState();
    scheduleFuture = getSchedulesUsers();
  }

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getSchedulesUsers() async {
    User? user = FirebaseAuth.instance.currentUser;
    print('User UID: ${user?.uid}');

    // Informações do usuário logado
    DocumentSnapshot<Map<String, dynamic>> userData =
        await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();

    CollectionReference<Map<String, dynamic>> scheduleCollectionRef =
        FirebaseFirestore.instance.collection('users').doc(user?.uid).collection('schedule');

    // Obtém os documentos da subcoleção "schedule"
    QuerySnapshot<Map<String, dynamic>> scheduleSnapshot =
        await scheduleCollectionRef.get();
    
    print('Schedule Documents: ${scheduleSnapshot.docs}');
    return scheduleSnapshot.docs;
  }

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
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())),
        ),
      ),
      body: FutureBuilder(
        future: scheduleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar os agendamentos.'),
            );
          } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Center(
              child: Text('Nenhum agendamento encontrado.'),
            );
          } else {
            List<DocumentSnapshot<Map<String, dynamic>>> schedules = (snapshot.data as List).cast<DocumentSnapshot<Map<String, dynamic>>>();
            return ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                return CustomCardWidget(data: schedules[index].data()!);
              },
            );
          }
        },
      ),
    );
  }
}

class CustomCardWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  CustomCardWidget({required this.data});


  @override
  Widget build(BuildContext context) {
    String shalonName = data['shalonName'] ?? 'Nome não disponível';
    String horario = data['horario'];
    Timestamp timestamp = data['date'];
    DateTime scheduleDate = timestamp.toDate();
    
    // Formatando a data como string no formato desejado
    String formattedDate = '${scheduleDate.day} de ${_getMonthName(scheduleDate.month)} de ${scheduleDate.year} ${horario}';

    List<String> services = List<String>.from(data['services']);
    String servicesString = services.join(', ');
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
                  height: 100.0,
                  width: 100.0,
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
                    shalonName,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 1.0),
                  // Linha 2
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 1.0),
                  // Linha 2
                  Text(
                    "Serviços: $servicesString",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 0.0),
                  Text(
                    "Total: R\$35",
                    style: TextStyle(
                      fontSize: 12.0,
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
                          minimumSize:  ui.Size(0, 0),
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
                          minimumSize:  ui.Size(0, 0),
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
                          minimumSize: ui.Size(0, 0),
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

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'jan';
      case 2:
        return 'fev';
      case 3:
        return 'mar';
      case 4:
        return 'abr';
      case 5:
        return 'mai';
      case 6:
        return 'jun';
      case 7:
        return 'jul';
      case 8:
        return 'ago';
      case 9:
        return 'set';
      case 10:
        return 'out';
      case 11:
        return 'nov';
      case 12:
        return 'dez';
      default:
        return '';
    }
  }

  String _addLeadingZero(int value) {
    return value < 10 ? '0$value' : '$value';
  }
}

void main() {
  runApp(MaterialApp(
    home: SchedulePage(),
  ));
}
