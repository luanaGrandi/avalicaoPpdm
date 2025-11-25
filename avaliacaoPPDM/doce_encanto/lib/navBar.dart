import 'package:doce_encanto/carrinho.dart';
import 'package:doce_encanto/cursos.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class NavBar extends StatefulWidget {
  final String nomeUsuario;

  const NavBar({super.key, required this.nomeUsuario});

  @override
  State<NavBar> createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  int currentIndex = 0;

  void changeindex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  List<Widget> get screens => [
        HomePage(nomeUsuario: widget.nomeUsuario),
        TelaCarrinho(nomeUsuario: widget.nomeUsuario),
        TelaCursos(nomeUsuario: widget.nomeUsuario),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) => changeindex(value),
        selectedItemColor: const Color(0xFF6F2940),
        unselectedItemColor: const Color(0xFFB88194),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Carrinho"),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: "Cursos"),
        ],
      ),
    );
  }
}
