import 'package:flutter/material.dart';
import 'package:regradocorte_app/pages/perfil_outers.page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Employee {
  final String name;
  final String role;
  final String availability;
  final String imageUrl;

  Employee({
    required this.name,
    required this.role,
    required this.availability,
    required this.imageUrl,
  });
}


class MiniCardListTabs extends StatefulWidget {
  final Function(String, String, int, String) onCardClick;
  final String userUuid;
  final String bio;


  MiniCardListTabs({required this.onCardClick, required this.userUuid, required this.bio});

  @override
  _MiniCardListTabsState createState() => _MiniCardListTabsState();
}



class _MiniCardListTabsState extends State<MiniCardListTabs> {
  List<Employee> employees = [];
  late Future<void> userDataFuture;
 
  // Método para inicializar o Firebase
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  Future<void> loadShalonAndEmployes() async {
    DocumentSnapshot<Map<String, dynamic>> userOwnerData =
        await FirebaseFirestore.instance.collection('users').doc(widget.userUuid).get();  
                
    DocumentSnapshot<Map<String, dynamic>> shalon =
      await FirebaseFirestore.instance.collection('shalon').doc(userOwnerData.data()?['salonId']).get();

    // Obtendo a referência da subcoleção "employes"
    CollectionReference employesCollectionRef = shalon.reference.collection('employees');
    // Obtendo os documentos da subcoleção "employes"
    QuerySnapshot<Map<String, dynamic>> employesSnapshot =
    await employesCollectionRef.get() as QuerySnapshot<Map<String, dynamic>>;

    // Iterando sobre os documentos da subcoleção "employes"
    employesSnapshot.docs.forEach((employeDoc) {
      // Aqui, você pode acessar os dados de cada documento da subcoleção
      Employee employee = Employee(
        name: employeDoc.data()?['name'] ?? '',
        role: employeDoc.data()?['role'] ?? '',
        availability: 'Disponível',
        imageUrl: 'assets/images/cabelo.jpeg', // Substitua isso pela lógica real para obter a URL da imagem
      );

      // Adicionando o funcionário à lista de funcionários
      employees.add(employee);
    });

    // Aqui, você terá a lista completa de funcionários
    print('Lista de funcionários: $employees');
  }

  @override
  void initState() {
    super.initState();
    userDataFuture = loadShalonAndEmployes();
  }
  
  String selectedServiceTitle = '';
  String userUuid = '';
  String selectedServiceDescription = '';

  int selectedServiceId = 0;
  int selectedTabIndex = 0; // Adicionado
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Scaffold(
          backgroundColor:Color.fromARGB(255, 42, 41, 41),
          body: Column(
            children: [
              TabBar(
                onTap: (index) {
                  setState(() {
                    selectedTabIndex = index;
                  });
                },
                tabs: [
                  buildTab('Sobre Mim'),
                  buildTab('Serviços'),
                  buildTab('Funcionários'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    buildAboutMeTab(),
                    buildServicesTab(selectedServiceId, userUuid),
                    buildEmpoyersTab()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTab(String title) {
    return Tab(
      child: 
      Text(title,  
        style: TextStyle(
          color: Colors.orange,
        )
      ),
    );
  }

 Widget buildAboutMeTab() {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.bio,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget buildServicesTab(int tabIndex, String userUuid) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: MiniCardList(
        userUuid: userUuid,
        onCardClick: (String title, String description, int id, String userUuid) {
          setState(() {
            selectedServiceTitle = title;
            selectedServiceDescription = description;
            selectedServiceId = id;
            userUuid = userUuid;
          });
          widget.onCardClick(selectedServiceTitle, selectedServiceDescription, selectedServiceId, userUuid);
        },
        selectedTabIndex: tabIndex,
      ),
    );
  }


  Widget buildEmpoyersTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: buildEmployeesTabContent(),
      ),
    );
  }


  Widget buildEmployeesTabContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Funcionários",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        // Lista de cards de funcionários
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: employees.length,
          itemBuilder: (context, index) {
            return buildEmployeeCard(employees[index]);
          },
        ),
      ],
    );
  }

  Widget buildEmployeeCard(Employee employee) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/profileOuters');
      },
      child: Card(
        color: Color.fromARGB(255, 42, 41, 41),
        margin: EdgeInsets.only(bottom: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Coluna 1: Foto do usuário
              Expanded(
                flex: 2,
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: AssetImage(employee.imageUrl),
                  backgroundColor: Colors.white, // Cor de fundo para o avatar
                ),
              ),
              SizedBox(width: 16.0),
              // Coluna 2: Nome e Disponibilidade
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Linha 1: Nome
                    Text(
                      employee.name,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    // Linha 2: Disponibilidade
                    Text(
                      '${employee.availability}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
 
}

class MiniCardList extends StatelessWidget {
  final Function(String, String, int, String) onCardClick;
  final int selectedTabIndex; // Adicionado
  final String userUuid;

  MiniCardList({required this.onCardClick, required this.selectedTabIndex, required this.userUuid}); // Adicionado


  Future<void> getServices() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userData =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      DocumentSnapshot<Map<String, dynamic>> shalon =
          await FirebaseFirestore.instance.collection('shalon').doc(userData.data()?['salonId']).get();

      Map<String, dynamic> services = shalon.data()?['services'];

      print("Estes sao os serviços. $services");
    }
  } 

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.0,
      width: double.infinity,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          MiniCard(
            id: 1,
            title: 'Cabelo',
            description: "R\$ 30,00",
            onClick: (int id) {
              onCardClick('Cabelo', 'R\$ 30,00 $selectedTabIndex', id, userUuid);
            },
            isSelected: selectedTabIndex == 1, // Adicionado
          ),
          Container(
            height: 2.0,
            color: Colors.orange ,
          ),
          // Adicione mais MiniCards conforme necessário
        ],
      ),
    );
  }
}

class MiniCard extends StatefulWidget {
  final int id;
  final String title;
  final String description;
  final Function(int) onClick;
  final bool isSelected;

  MiniCard({
    required this.id,
    required this.title,
    required this.description,
    required this.onClick,
    required this.isSelected,
  });

  @override
  _MiniCardState createState() => _MiniCardState();
}

class _MiniCardState extends State<MiniCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          widget.onClick(widget.id);
        },
        child: Container(
          margin: EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            color: widget.isSelected || isHovered
                ? Color.fromARGB(255, 77, 76, 76)
                : Color.fromARGB(255, 42, 41, 41),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
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
