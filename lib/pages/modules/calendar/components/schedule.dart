import 'package:flutter/material.dart';

class schedule extends StatelessWidget {
  final DateTime date;

  schedule({required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Agendamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDropdown(
              title: 'Escolha a Barbearia',
              items: ['Barbearia 1', 'Barbearia 2', 'Barbearia 3'],
            ),
            SizedBox(height: 16.0),
            _buildDropdown(
              title: 'Tipos de Serviço',
              items: ['Corte de Cabelo', 'Barba', 'Outros'],
            ),
            SizedBox(height: 16.0),
            _buildDropdown(
              title: 'Profissionais',
              items: ['Profissional 1', 'Profissional 2', 'Profissional 3'],
            ),
            SizedBox(height: 16.0),
            Wrap(
              spacing: 8.0, // Espaçamento horizontal entre os mini cards
              runSpacing: 8.0, // Espaçamento vertical entre as linhas de mini cards
              children: [
                _buildMiniCard('14:30'),
                _buildMiniCard('14:40'),
                _buildMiniCard('15:00'),
                _buildMiniCard('16:00'),
                _buildMiniCard('16:30'),
                _buildMiniCard('17:00'),
                _buildMiniCard('17:30'),
                _buildMiniCard('18:00'),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Adicione a lógica para processar os dados selecionados aqui
              },
              child: Text('Agendar'),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildMiniCard(String text) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text),
      ),
    );
  }
}

