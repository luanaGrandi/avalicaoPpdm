import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TelaAulas extends StatefulWidget {
  final String cursoNome;


  const TelaAulas({super.key, required this.cursoNome});

  @override
  State<TelaAulas> createState() => _TelaAulasState();
}

class _TelaAulasState extends State<TelaAulas> {
  List aulas = [];

  @override
  void initState() {
    super.initState();
    buscarAulas();
  }

  void buscarAulas() {
    FirebaseFirestore.instance
        .collection("cursos")
        .where("nome", isEqualTo: widget.cursoNome)
        .limit(1)
        .get()
        .then((query) {
      if (query.docs.isEmpty) return;

      final cursoId = query.docs.first.id;

      FirebaseFirestore.instance
          .collection("cursos")
          .doc(cursoId)
          .collection("aulas")
          .orderBy("numero")
          .snapshots()
          .listen((snapshot) {
        setState(() {
          aulas = snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return data;
          }).toList();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5F2),

      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            Image.asset('assets/img/logo.png', height: 60),
            const SizedBox(width: 10),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(15),
          child: Divider(height: 2, thickness: 2, color: Color(0xFFBEADA0)),
        ),
      ),

      body: aulas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(30),
              children: [
                const Text(
                  "Aulas do curso",
                  style: TextStyle(
                    color: Color(0xFF513D2E),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  widget.cursoNome,
                  style: const TextStyle(
                    color: Color(0xFFBEADA0),
                    fontSize: 22,
                  ),
                ),

                const SizedBox(height: 30),

                ...aulas.map((aula) => Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: _cardAula(aula),
                    )),
              ],
            ),
    );
  }


  Widget _cardAula(aula) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFF0BFD0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título da aula
          Text(
            aula["nome"] ?? "Sem título",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF513D2E),
            ),
          ),

          const SizedBox(height: 10),

          // Descrição da aula
          Text(
            aula["descricao"] ?? "Sem descrição",
            style: const TextStyle(
              fontSize: 17,
              color: Color(0xFF6F2940),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
