import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:regradocorte_app/pages/schedules.page.dart';


class Schedule extends StatefulWidget {
  final DateTime  date;
  final String    ownerShalonId;

  Schedule({required this.date, required this.ownerShalonId});

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  List<String> selectedServices = [];
  String selectedProfessional = '';
  String selectedTime = '';

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }
  //Buscando as informações do salão.
  Future<void> createScheduleShalon(date,  professionalName, serviceName, hours) async {
    User? user = FirebaseAuth.instance.currentUser;
    //Informações do usuario logado
    DocumentSnapshot<Map<String, dynamic>> userData =
        await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
    //const nameUser = userData?.name;
    //Informações do salão
    DocumentSnapshot<Map<String, dynamic>> userOwnerData =
      await FirebaseFirestore.instance.collection('users').doc(widget.ownerShalonId).get();

    DocumentSnapshot<Map<String, dynamic>> shalon =
      await FirebaseFirestore.instance.collection('shalon').doc(userOwnerData.data()?['salonId']).get();

    DateTime dateTimeWithHours = date.add(Duration(
      hours: int.parse(hours.split(':')[0]), // Extrai a parte das horas e converte para inteiro
      minutes: int.parse(hours.split(':')[1]), // Extrai a parte dos minutos e converte para inteiro
    ));
    
    // Verificar se o documento "shalon" existe
    // Calcular o preço total com base nos serviços selecionados
    if (shalon.exists) {
      // Acessar a coleção "schedule" dentro do documento "shalon"
      double totalAmount = _calculateTotal();

      shalon.reference.collection('schedule').add({
        'clientId': user?.uid,
        'cliente': userData['name'],
        'professional': professionalName,
        'services': serviceName,
        'horario': hours,
        'date': dateTimeWithHours,
         'price': totalAmount,
        'status': 'Pendente',
      });

      userData.reference.collection('schedule').add({
        'shalonId':userOwnerData.data()?['salonId'],
        'cliente': userData['name'],
        'shalonName': shalon.data()?['name'],
        'professional': professionalName,
        'services': serviceName,
        'horario': hours,
        'date': dateTimeWithHours,
        'status': 'Pendente',
         'price': totalAmount,
      });
      _showSuccessDialog();

      setState(() {
        selectedServices.clear();
        selectedProfessional = '';
        selectedTime = '';
      });
    } else {
      // O documento "shalon" não existe
      print('O documento "shalon" não foi encontrado.');
    }

  }



  List<Map<String, dynamic>> services = [
    {'id': 1, 'name': 'Corte de Cabelo', 'icon': Icons.content_cut, 'price': 20.0},
    {'id': 2, 'name': 'Barba', 'icon': Icons.airline_seat_flat_angled, 'price': 15.0},
    {'id': 3, 'name': 'Tintura', 'icon': Icons.brush, 'price': 30.0},
  ];

  List<Map<String, dynamic>> professionals = [
    {'id': 1, 'name': 'Felipe','urlImagem': 'https://picsum.photos/200/300'},
    {'id': 2, 'name': 'Davi','urlImagem': 'https://picsum.photos/200/300'},
    {'id': 3, 'name': 'Lucca','urlImagem': 'https://picsum.photos/200/300'},
  ];

  // Mapa que associa cada profissional a uma lista de horários disponíveis
  Map<String, List<String>> professionalTimeSlots = {
    'Felipe': ['14:30', '15:00', '15:30', '16:00'],
    'Davi': ['14:40', '15:10', '15:40', '16:10', '16:40'],
    'Lucca': ['15:20', '15:50', '16:20', '16:50'],
  };

  @override
  void initState() {
    super.initState();
    // Define o serviço inicial com base no serviceId
    //selectedServices.add(getServiceById(widget.serviceId));
  }

  String getServiceById(int serviceId) {
    // Método para obter o nome do serviço pelo serviceId
    for (var service in services) {
      if (service['id'] == serviceId) {
        return service['name'] as String;
      }
    }
    return ''; // Retorna uma string vazia se não encontrar correspondência
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 33, 33, 33),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 25, 25, 25),
        title: Text(
          'Detalhes do Agendamento',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.orange,
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Agendamento',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.0),
            _buildServiceList(),
            SizedBox(height: 16.0),
            _buildProfessionalsList(),
            SizedBox(height: 16.0),
            _buildTimeSlots(),
            SizedBox(height: 16.0),
            _buildTotalAmount(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Adicione a lógica para processar os dados selecionados aqui
                if (selectedServices.isNotEmpty &&
                    selectedProfessional.isNotEmpty &&
                    selectedTime.isNotEmpty) {
                  print('Agendar para ${widget.date} - Serviços: $selectedServices, Profissional: $selectedProfessional,  Horário: $selectedTime');

                  createScheduleShalon(widget.date, selectedProfessional, selectedServices, selectedTime);
                  //_showSuccessDialog();
                  
                  // Exemplo de como resetar os campos após o agendamento
                 
                } else {
                  print('Preencha todos os campos antes de prosseguir.');
                }
              },
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                elevation: 5,
              ),
              child: Text('Realizar Agendamento'),
            ),

          ],
        ),
      ),
    );
  }
  // Função para mostrar o AlertDialog de sucesso
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sucesso'),
          content: Text('O agendamento foi realizado com sucesso.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SchedulePage()));
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
  Widget _buildServiceList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipos de Serviço',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 8.0),
        Container(
          height: 100.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: services.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: _buildServiceIcon(services[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTotalAmount() {
    // Método para calcular e exibir o valor total dos serviços
    double totalAmount = _calculateTotal();
    return Text(
      'Total: R\$ ${totalAmount.toStringAsFixed(2)}',
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

   double _calculateTotal() {
    double total = 0.0;
    for (var selectedServiceName in selectedServices) {
      var selectedService = services.firstWhere(
        (service) => service['name'] == selectedServiceName,
        orElse: () => {},
      );
      total += selectedService['price'] ?? 0.0;
    }
    return total;
  }

  Widget _buildServiceIcon(Map<String, dynamic> service) {
    bool isSelected = selectedServices.contains(service['name'] as String);

    return GestureDetector(
      onTap: () {
        _toggleSelectedService(service['name'] as String);
      },
      child: Column(
        children: [
          Icon(service['icon'] ?? Icons.error, color: isSelected ? Colors.blue : Colors.white),
          SizedBox(height: 4.0),
          Text(
            service['name'] as String,
            style: TextStyle(fontSize: 12.0, color: isSelected ? Colors.blue : Colors.white),
          ),
        ],
      ),
    );
  }

  void _toggleSelectedService(String serviceName) {
    setState(() {
      if (selectedServices.contains(serviceName)) {
        selectedServices.remove(serviceName);
      } else {
        selectedServices.add(serviceName);
      }
    });
  }

  Widget _buildPicker({
    required String title,
    required List<String> items,
    required ValueChanged<int> onSelectedItemChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        Container(
          height: 150.0,
          child: CupertinoPicker(
            itemExtent: 40.0,
            onSelectedItemChanged: onSelectedItemChanged,
            children: items.map((item) => Center(child: Text(item, style: TextStyle(color: Colors.white)))).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildProfessionalsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profissionais',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 8.0),
        Container(
          height: 150.0,
          child: PageView.builder(
            itemCount: professionals.length,
            onPageChanged: (index) {
              setState(() {
                selectedProfessional = professionals[index]['name'] as String;
              });
            },
            itemBuilder: (context, index) {
              return _buildProfessionalCard(professionals[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfessionalCard(Map<String, dynamic> professional) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(
            //'https://example.com/${professional['name']}.jpg', // Substitua pela URL real da imagem
            '${professional['urlImagem']}'
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          professional['name'] as String,
          style: TextStyle(fontSize: 12.0, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildClickableCard(String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTime = text;
        });
      },
      child: Card(
        color: selectedTime == text ? Colors.blue : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(color: selectedTime == text ? Colors.white : null),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlots() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Horários Disponíveis',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 8.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: _buildTimeSlotsForProfessional(selectedProfessional),
        ),
      ],
    );
  }

  List<Widget> _buildTimeSlotsForProfessional(String professional) {
    // Obtém a lista de horários disponíveis para o profissional selecionado
    List<String> timeSlots = professionalTimeSlots[professional] ?? [];

    // Cria widgets para os horários disponíveis
    return timeSlots.map((time) => _buildClickableCard(time)).toList();
  }

 
}
