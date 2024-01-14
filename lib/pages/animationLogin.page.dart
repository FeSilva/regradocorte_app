import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VideoSplashScreen(),
    );
  }
}

class VideoSplashScreen extends StatefulWidget {
  @override
  _VideoSplashScreenState createState() => _VideoSplashScreenState();
}

class _VideoSplashScreenState extends State<VideoSplashScreen> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _videoController = VideoPlayerController.asset('assets/images/regradocorte.mp4')
      ..initialize().then((_) {
        // Após a inicialização do vídeo, você pode prosseguir para a tela de login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Vídeo de fundo
          VideoPlayer(_videoController),
          // Animação Flare sobreposta ao vídeo
          FlareActor(
            'assets/loading_animation.flr', // Substitua pelo caminho do seu arquivo Flare
            animation: 'loading',
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Tela de login
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela de Login'),
      ),
      body: Center(
        child: Text('Conteúdo da tela de login aqui'),
      ),
    );
  }
}
