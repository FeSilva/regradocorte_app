import 'dart:async';
import 'package:flutter/material.dart';

class ImageSliderCard extends StatefulWidget {
  final List<String> imageUrls;

  const ImageSliderCard({Key? key, required this.imageUrls}) : super(key: key);

  @override
  _ImageSliderCardState createState() => _ImageSliderCardState();
}

class _ImageSliderCardState extends State<ImageSliderCard> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);

    // Inicia o slider automático
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < widget.imageUrls.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildImageSlider();
  }

  Widget _buildImageSlider() {
    return Container(
      color: Colors.transparent,
      height: 200.0,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.imageUrls.length,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navegar para o próximo widget ao clicar na imagem
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalhesWidget(imageUrl: widget.imageUrls[index]),
                ),
              );
            },
            child: Container(
              width: 300.0,
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: AssetImage(widget.imageUrls[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Widget para a tela de detalhes
class DetalhesWidget extends StatelessWidget {

  final String imageUrl;

  const DetalhesWidget({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Imagem'),
      ),
      body: Center(
        child: Image.asset(imageUrl),
      ),
    );
  }
}
