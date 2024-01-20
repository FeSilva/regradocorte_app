import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:regradocorte_app/pages/perfil.page.dart';
import 'package:regradocorte_app/pages/schedules.page.dart';
import 'modules/newslide.dart';
import 'modules/categorys.dart';
import 'modules/calendar/calendar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

void main() => runApp(MaterialApp(
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.ltr, child: child!);
      },
      title: 'GNav',
      theme: ThemeData(
        primaryColor: Colors.grey[800],
      ),
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _userLocation = "Obtendo localização...";
  double lat = 0.0;
  double long = 0.0;

  @override
  void initState() {
    super.initState();
    getPosition();
    _selectedIndex = 0;
  }

  getPosition() async {
    try {
      Position position = await _positions();
      lat = position.latitude;
      long = position.longitude;
      String address = await getAddress(lat, long);
      setState(() {
        _userLocation = address;
      });
    } catch (e) {
      setState(() {
        _userLocation = 'Erro ao obter localização';
      });
    }
  }

  Future<Position> _positions() async {
    LocationPermission permission;
    bool ativado = await Geolocator.isLocationServiceEnabled();
    if (!ativado) {
      throw Exception('Por favor, habilite a localização no smartphone.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Você precisa liberar o acesso à sua localização.");
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<String> getAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark firstPlacemark = placemarks.first;
        String address =
            "${firstPlacemark.street}, ${firstPlacemark.subLocality}, ${firstPlacemark.locality}, ${firstPlacemark.country}";
        return address;
      } else {
        return "Endereço não encontrado";
      }
    } catch (e) {
      print("Erro ao obter endereço: $e");
      return "Erro ao obter endereço";
    }
  }

  @override
  Widget build(BuildContext context) {
    String dynamicTitle = _userLocation;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 25, 25, 25),
        actions: <Widget>[
          Container(
            width: 60,
            child: TextButton(
              child: Icon(
                Icons.notifications,
                color: Colors.orange,
              ),
              onPressed: () => {},
            ),
          ),
        ],
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 100),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _userLocation.length > 18
                      ? _userLocation.substring(0, 18) + '...'
                      : _userLocation,
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: 'Menu Icon',
          color: Colors.orange,
          onPressed: () {},
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 33, 33, 33),
        child: ListView(
          children: <Widget>[
            //widgetSalonList(),
            SizedBox(height: 10),
            ImageSliderCard(
              imageUrls: [
                'assets/images/slide1.jpg',
                'assets/images/slide1.jpg',
                'assets/images/slide1.jpg',
              ],
            ),
            MyCategoriesWidget(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 18, 18, 18),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.orange,
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.orange!,
              hoverColor: Colors.orange!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.orange!,
              color: Colors.orange,
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: LineIcons.calendar,
                  text: 'Agenda',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SchedulePage()),
                    );
                  },
                ),
                GButton(
                  icon: LineIcons.search,
                  text: 'Search',
                  onPressed: () {
                    _navigateToSearchScreen();
                  },
                ),
                GButton(
                  icon: LineIcons.user,
                  text: 'Profile',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                  }
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget widgetSalonList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            'Principais Referências',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 210, 210, 210),
            ),
          ),
        ),
        Container(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              SizedBox(width: 12),
              CircleAvatar(
                radius: 55,
                backgroundImage: AssetImage(
                  'assets/images/cabelo.jpeg',
                ),
                backgroundColor: Colors.red,
              ),
              SizedBox(width: 12),
              CircleAvatar(
                radius: 55,
                backgroundImage: AssetImage(
                  'assets/images/cabelo.jpeg',
                ),
                backgroundColor: Colors.greenAccent,
              ),
              SizedBox(width: 12),
              CircleAvatar(
                radius: 55,
                backgroundImage: AssetImage(
                  'assets/images/cabelo.jpeg',
                ),
                backgroundColor: Colors.indigoAccent,
              ),
              SizedBox(width: 12),
              CircleAvatar(
                radius: 55,
                backgroundImage: AssetImage(
                  'assets/images/cabelo.jpeg',
                ),
                backgroundColor: Colors.amber,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToSearchScreen() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SearchScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutQuart;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white),
          ),
          onChanged: (value) {
            // Handle search logic here
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              // Clear search results or update the UI accordingly
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item $index'),
          );
        },
      ),
    );
  }
}
