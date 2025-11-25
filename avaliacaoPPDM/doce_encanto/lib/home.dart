import 'package:doce_encanto/carrinho.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  final String nomeUsuario;

  const HomePage({super.key, required this.nomeUsuario});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List produtos = [];

  @override
  void initState() {
    super.initState();
    buscarProdutos();
  }

  void buscarProdutos() {
    FirebaseFirestore.instance.collection("produtos").snapshots().listen((
      snapshot,
    ) {
      setState(() {
        produtos = snapshot.docs.map((doc) => doc.data()).toList();
      });
    });
  }

    
  Future<void> adicionarAoCarrinho(produto) async {
    await FirebaseFirestore.instance.collection("carrinho").add({
      "nome": produto["nome"],
      "descricao": produto["descricao"],
      "preco": produto["preco"],
      "url_img": produto["url_img"],
    });

    //ScaffoldMessenger -> responsalvel por mostrar imagens "flutuantes" na sua tela
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar( //SnackBar -> feedback rapido para dar ao cliente
        content: Text("Produto adicionado ao carrinho!"), //mensagem que será exibida
        backgroundColor: Color(0xFF6F2940),
        duration: Duration(seconds: 2), //o tempo q vai ficar visivel
      ),
    );
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
      body: ListView(
        padding: const EdgeInsets.all(40),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/img/teste.png',
              width: 100,
              height: 340,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            "Nossos Produtos",
            style: TextStyle(
              color: Color(0xFF513D2E),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 30),

          if (produtos.length >= 4) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [_cardProduto(produtos[0]), _cardProduto(produtos[1])],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [_cardProduto(produtos[2]), _cardProduto(produtos[3])],
            ),
          ],
        ],
      ),
    );
  }

  Widget _cardProduto(produto) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.35,
      height: MediaQuery.of(context).size.height * 0.29,
      padding: const EdgeInsets.all(5),
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
              produto["url_img"],
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 10),
          Text(
            produto["nome"],
            style: const TextStyle(
              fontSize: 19,

              fontWeight: FontWeight.bold,
              color: Color(0xFF513D2E),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            produto["descricao"],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, color: Color(0xFFBEADA0)),
          ),

          const SizedBox(height: 13),

          Text(
            "R\$ ${produto["preco"]}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF6F2940),
            ),
          ),

          const SizedBox(height: 16),

          Center(
            child: ElevatedButton(
              onPressed: () {
                adicionarAoCarrinho(produto);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF0BFD0),
                minimumSize: const Size(170, 40),
                padding: EdgeInsets.zero,
              ),
              child: const Text(
                "Encomendar",
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
