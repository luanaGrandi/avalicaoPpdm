import 'package:flutter/material.dart';

class TelaCarrinho extends StatelessWidget {
  const TelaCarrinho({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Tela de Carrinho",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
