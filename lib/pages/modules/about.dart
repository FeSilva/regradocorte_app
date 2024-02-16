import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:regradocorte_app/pages/modules/about/components/minicardslider.dart';
import 'package:regradocorte_app/pages/modules/calendar/calendar.dart';
import 'package:regradocorte_app/pages/schedules/scheduleShalong.page.dart';
import 'package:table_calendar/table_calendar.dart';

class AboutMeWidget extends StatefulWidget {
  final String ownerShalonId;

  AboutMeWidget({required this.ownerShalonId});

  @override
  _AboutMeWidgetState createState() => _AboutMeWidgetState();
}

class _AboutMeWidgetState extends State<AboutMeWidget> {
  String selectedServiceTitle = '';
  String selectedServiceDescription = '';
  int selectedServiceId = 0;
  String ownerId = '';

  String appBarTitle = 'Regra do Corte';
  String bio = 'Iniciando as atividades';

  bool showFAB = false;
  bool isUserDataLoaded = false;
  bool showBottomNavigationBar = false;
  late Future<void> userDataFuture;
  int _selectedIndex = 0;

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  Future<void> loadUserData() async {
    if (isUserDataLoaded) {
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userData =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      String userRole = userData.data()?['role'] ?? 'customer';

      DocumentSnapshot<Map<String, dynamic>> userOwnerData =
          await FirebaseFirestore.instance.collection('users').doc(widget.ownerShalonId).get();

      DocumentSnapshot<Map<String, dynamic>> shalon =
          await FirebaseFirestore.instance.collection('shalon').doc(userOwnerData.data()?['salonId']).get();

      if (userRole == 'customer' || userRole == 'shalonAdmin') {
        if (userRole == 'customer') {
          setState(() {
            appBarTitle = shalon.data()?['name'] ?? 'Exemplo nome do salao';
            bio = shalon.data()?['bio'] ?? 'Exemplo nome do salao';
            showFAB = true;
          });
        } else {
          setState(() {
            appBarTitle = shalon.data()?['name'] ?? 'Exemplo nome do salao';
            bio = shalon.data()?['bio'] ?? 'Exemplo nome do salao';
            showBottomNavigationBar = true;
          });
        }
      }
      setState(() {
        isUserDataLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    userDataFuture = loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([initializeFirebase(), userDataFuture]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return buildScaffold();
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget buildScaffold() {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 33, 33, 33),
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: TextStyle(
            color: Colors.orange,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (showBottomNavigationBar)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditShalonInfoScreen(ownerShalonId: widget.ownerShalonId, shalonName: appBarTitle, bioShalon: bio),
                  ),
                );
              },
            ),
        ],
        leading: showFAB
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.orange,
                onPressed: () => Navigator.pop(context, false),
              )
            : IconButton(
                icon: Icon(Icons.menu),
                color: Colors.orange,
                onPressed: () => (),
              ),
        backgroundColor: Color.fromARGB(255, 25, 25, 25),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: PageView(
                        children: [
                          buildImageSlide('assets/images/logo.jpg'),
                          buildImageSlide('assets/images/background.png'),
                          buildImageSlide('assets/images/cabelo.jpeg'),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 42, 41, 41),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 30.0,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Horário:',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Terça a Sábado: 08h00 às 18h00',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    MiniCardListTabs(
                      userUuid: widget.ownerShalonId,
                      bio: bio,
                      onCardClick: (String title, String description, int id, String userUuid) {
                        setState(() {
                          selectedServiceTitle = title;
                          selectedServiceDescription = description;
                          selectedServiceId = id;
                          userUuid = userUuid;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            // Conteúdo principal aqui...
          ),
        ),
      ),
      floatingActionButton: showFAB
          ? FloatingActionButton.extended(
              onPressed: () async {
                if (selectedServiceTitle.isNotEmpty &&
                    selectedServiceDescription.isNotEmpty) {
                  User? user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentCalendar(selectedServiceId, widget.ownerShalonId),
                      ),
                    );
                  } else {
                    // Tratamento adequado aqui
                  }
                } else {
                  // Mensagem de erro ou tratamento adequado para nenhum serviço selecionado
                }
              },
              label: Text('Realizar Agendamento'),
              icon: Icon(Icons.calendar_today),
              backgroundColor: Colors.orange,
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: showBottomNavigationBar
          ? Container(
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
                            MaterialPageRoute(builder: (context) => ScheduleShalonPage()),
                          );
                        },
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
            )
          : null,
    );
  }

  Widget buildImageSlide(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
      ),
    );
  }
}



class EditShalonInfoScreen extends StatefulWidget {
  final String ownerShalonId;
  final String shalonName;
  final String bioShalon;

  EditShalonInfoScreen({required this.ownerShalonId, required this.shalonName, required this.bioShalon});

  @override
  _EditShalonInfoScreenState createState() => _EditShalonInfoScreenState();
}

class _EditShalonInfoScreenState extends State<EditShalonInfoScreen> {
  TextEditingController shalonNameController = TextEditingController();
  TextEditingController biografiaController = TextEditingController();

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    super.initState();
    shalonNameController.text = widget.shalonName;
    biografiaController.text = widget.bioShalon;
    getOperatingDays();
  }

 
  List<ServiceModel> services = [
    ServiceModel(id: 1, name: 'Corte de Cabelo', icon: Icons.content_cut),
    ServiceModel(id: 2, name: 'Barba', icon: Icons.airline_seat_flat_angled),
    ServiceModel(id: 3, name: 'Tintura', icon: Icons.brush),
    ServiceModel(id: 4, name: 'Sombrancelha', icon: Icons.brush),

  ];
  List<ServiceModel> selectedServices = [];
  List<String> selectedDays = [];
  Map<String, List<String>> selectedTimings = {};
  bool showSelectedTimingsList = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: Text('Editar Informações'),
                pinned: true,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                bottom: TabBar(
                  tabs: [
                    Tab(text: 'Informações'),
                    Tab(text: 'Serviços'),
                    Tab(text: 'Horários'),
                    Tab(text: 'Funcionarios'),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // Escolher imagens
                        },
                        child: Text('Imagens de Capa'),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: shalonNameController,
                        decoration: InputDecoration(labelText: 'Nome do Salão *'),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: biografiaController,
                        decoration: InputDecoration(labelText: 'Biografia *'),
                        maxLines: null,
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          saveChangesInfo();
                        },
                        child: Text('Salvar Alterações'),
                      ),
                    ],
                  ),
                ),
              ),
              buildServiceListWithPrices(),
              Column(
                children: [
                  SizedBox(height: 16.0),
                  Text(
                    'Dias de Funcionamento',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  buildDayButtons(),
                  SizedBox(height: 16.0),
                  Text(
                    'Horários Disponíveis',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  buildTimeSlots(),
                  //buildScheduleList(),
                ],
              ),
              buildServiceListWithPrices(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildScheduleList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: selectedTimings.keys.map((day) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Horários para $day:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            buildSelectedTimingsList(day),
            SizedBox(height: 16.0),
          ],
        );
      }).toList(),
    );
  }

  Widget buildSelectedTimingsList(String day) {
    final timings = selectedTimings[day] ?? [];

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: timings.map((timing) {
        return Chip(
          label: Text(timing),
          onDeleted: () {
            toggleTimingSelection(day, timing);
          },
        );
      }).toList(),
    );
  }

  Widget buildDayButtons() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: daysOfWeek.map((day) {
        return ElevatedButton(
          onPressed: () {
            toggleDaySelection(day['display'] ?? '');
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              return selectedDays.contains(day['display'] ?? '') ? Colors.blue : Colors.grey;
            }),
          ),
          child: Text(
            day['display'] ?? '',
            style: TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
    );
  }

  Widget buildTimeSlotsList(String day) {
    final availableTimings = timeSlots
        .where((timing) => !selectedTimings.values.any((list) => list.contains(timing['value'])))
        .toList();

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: availableTimings.map((time) {
        return ElevatedButton(
          onPressed: () {
            toggleTimingSelection(day, time['value'] ?? '');
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              return selectedTimings[day]?.contains(time['value']) ?? false
                  ? Colors.blue
                  : Colors.grey;
            }),
          ),
          child: Text(
            time['display'] ?? '',
            style: TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
    );
  }

  Widget buildSelectedTimings(String day) {
    final timings = selectedTimings[day] ?? [];

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: timings.map((timing) {
        return Chip(
          label: Text(timing),
          onDeleted: () {
            toggleTimingSelection(day, timing);
          },
        );
      }).toList(),
    );
  }

  Widget buildTimeSlots() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: selectedDays.map((day) {
        return ElevatedButton(
          onPressed: () {
            showTimesList(day);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
 
              return selectedTimings[day]?.isNotEmpty == true ? Colors.blue : Colors.grey;
            }),
          ),
          child: Text(
            'Horários para ${day}',
            style: TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
    );
  }

  Widget buildServiceListWithPrices() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: Icon(service.icon),
                            title: Text(
                              service.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Checkbox(
                              value: selectedServices.contains(service),
                              onChanged: (value) {
                                toggleServiceSelection(service, value);
                              },
                            ),
                          ),
                          if (selectedServices.contains(service))
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, top: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.attach_money,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Valor: ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        hintText: 'Informe o valor',
                                        border: OutlineInputBorder(),
                                        suffixIcon: Icon(Icons.monetization_on),
                                      ),
                                      keyboardType: TextInputType.number,
                                      initialValue: service.price.toString(),
                                      onChanged: (value) {
                                        updateServicePrice(service, value);
                                      },
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
              );
            },
          ),
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () {
            saveChangesServices();
          },
          child: Text('Salvar Alterações'),
        ),
      ],
    );
  }

  Widget buildDayList(String day) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: timeSlots.map((time) {
        return ElevatedButton(
          onPressed: () {
            toggleTimingSelection(day, time['value'] ?? '');
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              return selectedTimings[day]?.contains(time['value']) ?? false
                  ? Colors.blue
                  : Colors.grey;
            }),
          ),
          child: Text(
            '${time['value']}',
            style: TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
    );
  }

  Widget buildTimingList(String day) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: selectedTimings[day]?.map((timing) {
        return ElevatedButton(
          onPressed: () {
            toggleTimingSelection(day, timing);
            Navigator.pop(context); // Fechar o diálogo após selecionar um horário
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              return selectedTimings[day]?.contains(timing) ?? false
                  ? Colors.blue
                  : Colors.grey;
            }),
          ),
          child: Text(
            'Horário $timing',
            style: TextStyle(color: Colors.white),
          ),
        );
      }).toList() ?? [],
    );
  }

  void toggleDaySelection(String day) {
    setState(() {
      if (selectedDays.contains(day)) {
        selectedDays.remove(day);
        selectedTimings.remove(day); // Remova a associação de horários ao desmarcar o dia
      } else {
        selectedDays.add(day);
        selectedTimings.putIfAbsent(day, () => []); // Inicializa a lista de horários para o dia selecionado
      }
    });
  }

  void toggleTimingSelection(String day, String timing) {
    setState(() {
      if (selectedTimings.containsKey(day)) {
        if (selectedTimings[day]!.contains(timing)) {
          selectedTimings[day]!.remove(timing);
        } else {
          selectedTimings[day]!.add(timing);
        }
      } else {
        selectedTimings[day] = [timing];
      }
    });
  }

  void toggleServiceSelection(ServiceModel service, bool? value) {
    setState(() {
      if (value != null && value) {
        selectedServices.add(service);
      } else {
        selectedServices.remove(service);
      }
    });
  }

  void updateServicePrice(ServiceModel service, String value) {
    setState(() {
      service.price = double.tryParse(value) ?? 0.0;
    });
  }

  void showTimesList(day) {   
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Escolha os Horarios'),
          content: buildDayList(day),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                createHourlyDays();
                setState(() {
                  showSelectedTimingsList = true; // Atualiza a visibilidade da lista ao fechar o diálogo
                });
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Parabéns'),
          content: Text('As informações do seu perfil foram salvas.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                //Navigator.push(context, MaterialPageRoute(builder: (context) => SchedulePage()));
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveChangesInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userData =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      // Referência para o documento do Salão
      DocumentReference shalonDocRef = _firestore.collection('shalon').doc(userData.data()?['salonId']);
      await shalonDocRef.update({'name': shalonNameController.text, 'bio': biografiaController.text});
    }
  }

  Future<void> saveChangesServices() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userData =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      DocumentSnapshot<Map<String, dynamic>> shalon =
          await FirebaseFirestore.instance.collection('shalon').doc(userData.data()?['salonId']).get();

      CollectionReference<Map<String, dynamic>> servicesCollection =
          shalon.reference.collection('services');

      // Obtenha os documentos existentes na coleção 'services'
      QuerySnapshot<Map<String, dynamic>> existingServices = await servicesCollection.get();

      // Remova cada documento existente na coleção 'services'
      for (QueryDocumentSnapshot<Map<String, dynamic>> document in existingServices.docs) {
        await document.reference.delete();
      }
      // Adicione os novos serviços
      List<Map<String, dynamic>> data = selectedServices.map((service) => service.toMap()).toList();
      for (Map<String, dynamic> serviceData in data) {
        await servicesCollection.add(serviceData);
      }
    }
  }

  Future<void> createHourlyDays() async {
    User? user = FirebaseAuth.instance.currentUser;

    DocumentSnapshot<Map<String, dynamic>> userData =
        await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();

    DocumentSnapshot<Map<String, dynamic>> shalon =
        await FirebaseFirestore.instance.collection('shalon').doc(userData.data()?['salonId']).get();

    DocumentReference operatingDaysRef = shalon.reference.collection('operating_days').doc('days');
    await operatingDaysRef.set(selectedTimings);
  }

  Future<void> getOperatingDays() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> userData =
            await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        
        DocumentSnapshot<Map<String, dynamic>> shalon =
            await FirebaseFirestore.instance.collection('shalon').doc(userData.data()?['salonId']).get();

        QuerySnapshot<Map<String, dynamic>> operatingDaysSnapshot =
            await shalon.reference.collection('operating_days').get();

        if (operatingDaysSnapshot.docs.isNotEmpty) {
          // Acesse diretamente o primeiro documento da coleção
          DocumentSnapshot<Map<String, dynamic>> operatingDaysDoc = operatingDaysSnapshot.docs.first;
          
          // Verifique se os valores são List<dynamic> antes de atribuir a selectedTimings
          Map<String, List<String>> tempSelectedTimings = {};

          operatingDaysDoc.data()?.forEach((key, value) {
            if (value is List<dynamic>) {
              // Faça a conversão de List<dynamic> para List<String>
              tempSelectedTimings[key] = List<String>.from(value);
            }
          });

          // Atualize o estado com os dias e horários recuperados do Firebase
          setState(() {
            selectedTimings = tempSelectedTimings;
            selectedDays = tempSelectedTimings.keys.toList();
          });

          print('Dados dos horários operacionais recuperados com sucesso: $tempSelectedTimings');
        } else {
          print('A coleção operating_days está vazia.');
        }
      } catch (e) {
        print('Erro ao recuperar os horários operacionais: $e');
        // Lide com o erro conforme necessário
      }
    }
  }


}

class ServiceModel {
  final int id;
  final String name;
  final IconData icon;
  double price;

  ServiceModel({required this.id, required this.name, required this.icon, this.price = 0.0});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon.codePoint, // Obtém o valor do código do ícone
      'price': price,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

List<Map<String, String>> get daysOfWeek => [
      {'display': 'Segunda', 'value': 'Seg'},
      {'display': 'Terça', 'value': 'Ter'},
      {'display': 'Quarta', 'value': 'Qua'},
      {'display': 'Quinta', 'value': 'Qui'},
      {'display': 'Sexta', 'value': 'Sex'},
      {'display': 'Sábado', 'value': 'Sáb'},
      {'display': 'Domingo', 'value': 'Dom'},
    ];

List<Map<String, String>> get timeSlots => [
      {'display': '08:00', 'value': '08:00'},
      {'display': '09:00', 'value': '09:00'},
      {'display': '10:00', 'value': '10:00'},
      {'display': '11:00', 'value': '11:00'},
      {'display': '14:00', 'value': '14:00'},
      {'display': '15:00', 'value': '15:00'},
      {'display': '16:00', 'value': '16:00'},
      {'display': '17:00', 'value': '17:00'},
    ];