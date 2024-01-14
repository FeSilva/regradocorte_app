import 'package:flutter/material.dart';

class MiniCardListTabs extends StatefulWidget {
  final Function(String, String, int) onCardClick;

  MiniCardListTabs({required this.onCardClick});

  @override
  _MiniCardListTabsState createState() => _MiniCardListTabsState();
}

class _MiniCardListTabsState extends State<MiniCardListTabs> {
  String selectedServiceTitle = '';
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
                  buildTab('Horários'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    buildAboutMeTab(),
                    buildServicesTab(selectedServiceId),
                    buildScheduleTab(),
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
        // Conteúdo da aba Sobre Mim aqui...
      ),
    );
  }

  Widget buildServicesTab(int tabIndex) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: MiniCardList(
        onCardClick: (String title, String description, int id) {
          setState(() {
            selectedServiceTitle = title;
            selectedServiceDescription = description;
            selectedServiceId = id;
          });
          widget.onCardClick(selectedServiceTitle, selectedServiceDescription, selectedServiceId);
        },
        selectedTabIndex: tabIndex,
      ),
    );
  }

  Widget buildScheduleTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        // Conteúdo da aba Horários aqui...
      ),
    );
  }
}

class MiniCardList extends StatelessWidget {
  final Function(String, String, int) onCardClick;
  final int selectedTabIndex; // Adicionado

  MiniCardList({required this.onCardClick, required this.selectedTabIndex}); // Adicionado

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
              onCardClick('Cabelo', 'R\$ 30,00 $selectedTabIndex', id);
            },
            isSelected: selectedTabIndex == 1, // Adicionado
          ),
          Container(
            height: 2.0,
            color: Colors.orange ,
          ),
          MiniCard(
            id: 2,
            title: 'Barba',
            description: "R\$ 15,00",
            onClick: (int id) {
              onCardClick('Barba', 'R\$ 15,00 $selectedTabIndex', id);
            },
            isSelected: selectedTabIndex == 2, // Adicionado
          ),
          Container(
            height: 2.0,
            color: Colors.orange ,
          ),
          MiniCard(
            id: 3,
            title: 'Cabelo + Barba',
            description: "R\$ 45,00",
            onClick: (int id) {
              onCardClick('Cabelo + Barba', 'R\$ 45,00 $selectedTabIndex', id);
            },
            isSelected: selectedTabIndex == 3, // Adicionado
          ),
          Container(
            height: 2.0,
            color:  Colors.orange ,
          ),
          MiniCard(
            id: 4,
            title: 'Outro Serviço',
            description: "R\$ 50,00",
            onClick: (int id) {
              onCardClick('Outro Serviço', 'R\$ 50,00 $selectedTabIndex', id);
            },
            isSelected: selectedTabIndex == 4, // Adicionado
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
