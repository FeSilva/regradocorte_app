import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Schedule extends StatefulWidget {
  final DateTime date;
  final int serviceId;

  Schedule({required this.date, required this.serviceId});

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  List<String> selectedServices = [];
  String selectedProfessional = '';
  String selectedTime = '';

  List<Map<String, dynamic>> services = [
    {'id': 1, 'name': 'Corte de Cabelo'},
    {'id': 2, 'name': 'Barba'},
    {'id': 3, 'name': 'Cabelo + Barba'},
    {'id': 4, 'name': 'Outros'},
  ];

  List<Map<String, dynamic>> professionals = [
    {'id': 0, 'name': 'Selecione um Profissional'},
    {'id': 1, 'name': 'Felipe'},
    {'id': 2, 'name': 'Davi'},
    {'id': 3, 'name': 'Lucca'},
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
    selectedServices.add(getServiceById(widget.serviceId));
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
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.0),
            _buildServiceList(),
            SizedBox(height: 16.0),
            _buildPicker(
              title: 'Profissional',
              items: professionals.map((professional) => professional['name'] as String).toList(),
              onSelectedItemChanged: (int index) {
                setState(() {
                  selectedProfessional = professionals[index]['name'] as String;
                });
              },
            ),
            SizedBox(height: 16.0),
            _buildTimeSlots(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Adicione a lógica para processar os dados selecionados aqui
                if (selectedServices.isNotEmpty) {
                  print('Agendar para ${widget.date} - Serviços: $selectedServices, Profissional: $selectedProfessional, ID: ${widget.serviceId}, Horário: $selectedTime');
                } else {
                  print('Selecione pelo menos um serviço antes de prosseguir.');
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
              child: Text('Realizar Agendamento'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipos de Serviço',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        Container(
          height: 150.0,
          child: ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              return CheckboxListTile(
                title: Text(services[index]['name'] as String),
                value: selectedServices.contains(services[index]['name']),
                onChanged: (bool? value) {
                  setState(() {
                    if (value != null) {
                      if (value) {
                        selectedServices.add(services[index]['name'] as String);
                      } else {
                        selectedServices.remove(services[index]['name']);
                      }
                    }
                  });
                },
              );
            },
          ),
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
            children: items.map((item) => Center(child: Text(item))).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlots() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Horários Disponíveis',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
