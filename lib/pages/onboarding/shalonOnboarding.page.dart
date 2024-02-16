import 'package:flutter/material.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:regradocorte_app/pages/home.page.dart';


class ShalonOnboarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onboarding App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ConcentricAnimationOnboarding(),
    );
  }
}

final pages = [
  const PageData(
    icon: Icons.celebration,
    title: "Olá, estamos muito felizes em ter você conosco !",
    subtitle:'Vamos iniciar nosso cadastro ?',
    bgColor: Color.fromARGB(255, 222, 127, 12),
    textColor: Colors.white,
  ),
  PageData(
    icon: Icons.verified_user,
    title: "Como podemos te chamar ?",
    //subtitle: "Cadastro de usuário",
    bgColor: Color.fromARGB(255, 25, 25, 25),
    textColor: Colors.orange,
    extraContent: Form(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
          
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
  PageData(
    icon: Icons.money_off,
    title: "Bem-vindo ",
    bgColor: Color(0xffffffff),
    textColor: Colors.orange,
    extraContent: Form(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
];

class ConcentricAnimationOnboarding extends StatelessWidget {
  const ConcentricAnimationOnboarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ConcentricPageView(
        colors: pages.map((p) => p.bgColor).toList(),
        radius: screenWidth * 0.1,
        nextButtonBuilder: (context) => Padding(
          padding: const EdgeInsets.only(left: 3),
          child: Icon(
            Icons.navigate_next,
            size: screenWidth * 0.08,
          ),
        ),
        scaleFactor: 2,
        itemBuilder: (index) {
          final page = pages[index % pages.length];
          return SafeArea(
            child: _Page(page: page),
          );
        },
        onFinish: () {
          // Navegue para a tela inicial quando o onboarding for concluído
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
      ),
    );
  }
}

class PageData {
  final String? title;
  final IconData? icon;
  final Color bgColor;
  final Color textColor;
  final String? subtitle;
  final Widget? extraContent; // Novo campo para conteúdo extra

  const PageData({
    this.title,
    this.subtitle,
    this.icon,
    this.bgColor = Colors.white,
    this.textColor = Colors.black,
     this.extraContent,
  });
}

class _Page extends StatelessWidget {
  final PageData page;

  const _Page({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(shape: BoxShape.circle, color: page.textColor),
            child: Icon(
              page.icon,
              size: screenHeight * 0.1,
              color: page.bgColor,
            ),
          ),
          Text(
            page.title ?? "",
            style: TextStyle(
              color: page.textColor,
              fontSize: screenHeight * 0.035,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (page.subtitle != null)
            Text(
              page.subtitle!,
              style: TextStyle(
                color: page.textColor,
                fontSize: screenHeight * 0.025,
              ),
              textAlign: TextAlign.center,
            ),
          if (page.extraContent != null) page.extraContent!,
        ],
      ),
    );
  }
}
