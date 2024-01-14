import 'package:flutter/material.dart';
import './about.dart';
class MyCategoriesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          MyCategoryCard(
            title: 'Barber New Order',
            icon: Icons.category,
            color: Color.fromARGB(255, 42, 41, 41),
          ),
          MyCategoryCard(
            title: 'Felipe Corte"s',
            icon: Icons.category,
            color: Color.fromARGB(255, 42, 41, 41),
          ),
          MyCategoryCard(
            title: 'Barber New',
            icon: Icons.category,
            color: Color.fromARGB(255, 42, 41, 41),
          ),
          MyCategoryCard(
            title: 'Corte Certo',
            icon: Icons.category,
            color: Color.fromARGB(255, 42, 41, 41),
          ),
        ],
      ),
    );
  }
}


class MyCategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const MyCategoryCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutMeWidget()),
        );
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 8.0),
        child: Card(
          color: color,
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.jpg',
                        height: 80.0,
                        width: 80.0,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Aberto: 08h00 - 19h00',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(
                            Icons.attach_money,
                            color: Colors.white,
                            size: 18.0,
                          ),
                          Text(
                            '45,00',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 18.0,
                          ),
                          Text(
                            '45,00',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

