import 'package:flutter/material.dart';


class MiniCardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.0,
      width: double.infinity,  // Ocupa a largura máxima disponível
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          MiniCard(title: 'Cabelo', description: "R\$ 30,00"),
          MiniCard(title: 'Barba', description: "R\$ 15,00"),
          MiniCard(title: 'Cabelo + Barba', description: "R\$ 45,00"),
          MiniCard(title: 'Card 4', description: ''),
          MiniCard(title: 'Card 5', description: ''),
        ],
      ),
    );
  }
}

class MiniCard extends StatelessWidget {
  final String title;
  final String description;
  MiniCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2.0),
      //width: MediaQuery.of(context).size.width * 0.8, // Largura ajustada
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 42, 41, 41),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              description,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MiniCardList(),
  ));
}
