import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TelaCarrinho extends StatefulWidget {
  final String nomeUsuario;

  const TelaCarrinho({super.key, required this.nomeUsuario});

  @override
  State<TelaCarrinho> createState() => _TelaCarrinhoState();
}

class _TelaCarrinhoState extends State<TelaCarrinho> {
  Future<void> removerProduto(String idDoc) async {
    await FirebaseFirestore.instance.collection("carrinho").doc(idDoc).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Item removido do carrinho!"),
        backgroundColor: Color(0xFF6F2940),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> finalizarPedido() async {
  // Mostrar popup de finalizar o pedido
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Pedido Finalizado!",
          style: TextStyle(
            color: Color(0xFF6F2940),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "Seu pedido foi realizado com sucesso!",
          style: TextStyle(color: Color(0xFF513D2E)),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              //limpar o carrinho quando apertar em ok
              var docs = await FirebaseFirestore.instance.collection("carrinho").get();
              for (var doc in docs.docs) {
                await doc.reference.delete();
              }

              Navigator.pop(context); // fechar o popap
            },
            child: const Text(
              "OK",
              style: TextStyle(
                color: Color(0xFF6F2940),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}


  Future<void> aumentarQuantidade(String idDoc, int qtdAtual) async {
    await FirebaseFirestore.instance.collection("carrinho").doc(idDoc).update({
      "quantidade": qtdAtual + 1,
    });
  }

  Future<void> diminuirQuantidade(String idDoc, int qtdAtual) async {
    if (qtdAtual > 1) {
      await FirebaseFirestore.instance.collection("carrinho").doc(idDoc).update({
        "quantidade": qtdAtual - 1,
      });
    } else {
      removerProduto(idDoc);
    }
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
      backgroundColor: const Color.fromARGB(255, 249, 249, 249),

      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(40),
            child: ListView(
              padding: EdgeInsets.only(bottom: 160),
              children: [
                const Text(
                  "MEU CARRINHO",
                  style: TextStyle(
                    color: Color(0xFF513D2E),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("carrinho").snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    var itens = snapshot.data!.docs;

                    if (itens.isEmpty) {
                      return const Center(
                        child: Text(
                          "Seu carrinho está vazio!",
                          style: TextStyle(fontSize: 20, color: Color(0xFF6F2940)),
                        ),
                      );
                    }

                    return Column(
                      children: itens.map((doc) {
                        var dado = doc.data() as Map<String, dynamic>;
                        int quantidade = dado["quantidade"] ?? 1;
                        return _cardCarrinho(dado, doc.id, quantidade);
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("carrinho").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();

                var itens = snapshot.data!.docs;
                double totalGeral = 0.0;

                for (var doc in itens) {
                  var dado = doc.data() as Map<String, dynamic>;
                  int quantidade = dado["quantidade"] ?? 1;
                  double precoUnit = double.tryParse(dado["preco"].toString()) ?? 0.0;
                  totalGeral += quantidade * precoUnit;
                }

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8E5EC),
                    border: Border(top: BorderSide(color: Color(0xFFBEADA0), width: 2)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF513D2E),
                            ),
                          ),
                          Text(
                            "R\$ ${totalGeral.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6F2940),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            finalizarPedido();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFF0BFD0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Finalizar Pedido",
                            style: TextStyle(
                              color: Color(0xFF6F2940),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardCarrinho(Map<String, dynamic> dado, String idDoc, int quantidade) {
    double precoUnit = double.tryParse(dado["preco"].toString()) ?? 0.0;
    double precoTotal = precoUnit * quantidade;

    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFFF0BFD0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              dado["url_img"],
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dado["nome"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF513D2E),
                  ),
                ),
                const SizedBox(height: 25),

                Row(
                  children: [
                    GestureDetector(
                      onTap: () => diminuirQuantidade(idDoc, quantidade),
                      child: const Icon(Icons.remove,
                          size: 30, color: Color(0xFF513D2E)),
                    ),
                    const SizedBox(width: 10),

                    Text(
                      quantidade.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF513D2E),
                      ),
                    ),

                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => aumentarQuantidade(idDoc, quantidade),
                      child: const Icon(Icons.add,
                          size: 30, color: Color(0xFF513D2E)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Column(
            children: [
              GestureDetector(
                onTap: () => removerProduto(idDoc),
                child: const Icon(Icons.delete, color: Color(0xFFB88194)),
              ),
              const SizedBox(height: 50),
              Text(
                "R\$ ${precoTotal.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF6F2940),
                ),
              ),
              const Text(
                "Preço total",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6F2940),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
