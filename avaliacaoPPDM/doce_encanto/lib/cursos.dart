import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TelaCursos extends StatefulWidget {
  final String nomeUsuario;

  const TelaCursos({super.key, required this.nomeUsuario});

  @override
  State<TelaCursos> createState() => _TelaCursosState();
}

class _TelaCursosState extends State<TelaCursos> {
  List cursos = [];

  @override
  void initState() {
    super.initState();
    buscarCursos();
  }

  void buscarCursos() {
    FirebaseFirestore.instance.collection("cursos").snapshots().listen((snapshot) {
      setState(() {
        cursos = snapshot.docs.map((doc) => doc.data()).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            Image.asset('assets/img/logo.png', height: 60),
            const SizedBox(width: 20),
            Text(
              "Bem-vindo(a), ${widget.nomeUsuario}",
              style: const TextStyle(fontSize: 15, color: Colors.black),
            ),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(15),
          child: Divider(height: 2, thickness: 2, color: Color(0xFFBEADA0)),
        ),
      ),
      backgroundColor: const Color(0xFFFAF5F2),

      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          const Text(
            "Cursos de confeitaria!",
            style: TextStyle(
              color: Color(0xFF513D2E),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            "Aprenda com os melhores chefs",
            style: TextStyle(
              color: Color(0xFFBEADA0),
              fontSize: 25,
            ),
          ),

          const SizedBox(height: 30),

          if (cursos.isEmpty)
            const Center(child: CircularProgressIndicator())
          else
            ...cursos.map((curso) => Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: _cardCurso(curso),
            )),
        ],
      ),
    );
  }

  Widget _cardCurso(curso) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFFF0BFD0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              curso["url_img"],
              height: 170,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            curso["nome"],
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Color(0xFF513D2E),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "Chef: ${curso["chef"]}",
            style: const TextStyle(fontSize: 15, color: Color(0xFFBEADA0)),
          ),

          const SizedBox(height: 10),

          Text(
            "Duração: ${curso["tempoDuracao"]}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF6F2940),
            ),
          ),

          const SizedBox(height: 18),

          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF0BFD0),
                padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Começar Curso",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF6F2940),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
