
import 'package:flutter/material.dart';
class detailSchedule extends StatelessWidget {
  final DateTime date;

  detailSchedule({required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Agendamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildField('Nome', 'John Doe'),
            _buildField('Data', _formatDateTime(date)),
            _buildField('Endereço', 'Rua ABC, 123'),
            _buildField('Profissional', 'Profissional 1'),
            _buildField('Valor', 'R\$ 50,00'),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Adicione a lógica para processar os dados selecionados aqui
              },
              child: Text('Cancelar Agendamento'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        Text(
          value,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    // Adapte o formato da data e hora conforme necessário
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }

  Widget _buildDropdown({required String title, required List<String> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        DropdownButton<String>(
          isExpanded: true,
          value: items.first,
          onChanged: (String? newValue) {
            // Adicione a lógica para tratar a seleção do item aqui
          },
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}