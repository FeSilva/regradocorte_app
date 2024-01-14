import 'package:flutter/material.dart';

class Horario {
  final String diaSemana;
  final String horario;

  Horario({required this.diaSemana, required this.horario});
}


List<Horario> horarios = [
    Horario(diaSemana: 'Segunda-feira', horario: '08:00 - 18:00'),
    Horario(diaSemana: 'Terça-feira', horario: '08:00 - 18:00'),
    Horario(diaSemana: 'Quarta-feira', horario: '08:00 - 18:00'),
    Horario(diaSemana: 'Quinta-feira', horario: '08:00 - 18:00'),
    Horario(diaSemana: 'Sexta-feira', horario: '08:00 - 18:00'),
    Horario(diaSemana: 'Sábado', horario: '08:00 - 12:00'),
];

class HorarioList extends StatelessWidget {
  @override
  
  Widget build(BuildContext context) {
        return Container(
        padding: EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: horarios.length,
          itemBuilder: (context, index) {
            return HorarioItem(
              diaSemana: horarios[index].diaSemana,
              horario: horarios[index].horario,
            );
          },
        ),
      );
  }
}

class HorarioItem extends StatelessWidget {
  final String diaSemana;
  final String horario;

  HorarioItem({required this.diaSemana, required this.horario});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              diaSemana,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              horario,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

