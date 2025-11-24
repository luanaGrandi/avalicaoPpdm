import 'package:flutter/material.dart';

class TelaCursos extends StatelessWidget {
  const TelaCursos({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Tela de Cursos",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
