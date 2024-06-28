import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:dreampcbuilder/main.dart'; // Certifique-se de que o caminho está correto

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: Lottie.asset('assets/lottie/Animation - 1718151796539.json'), // Substitua pelo caminho correto do seu arquivo Lottie
      ),
      nextScreen: MyBuildPage(),
      
      splashTransition: SplashTransition.scaleTransition,
      splashIconSize: 700,
      backgroundColor: Color.fromARGB(255, 24, 84, 248), // Ajuste a cor de fundo conforme necessário
      duration: 3500, // Ajuste o tempo de exibição do splash screen em milissegundos
    );
  }
}

