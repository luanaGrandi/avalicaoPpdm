import 'package:doce_encanto/navBar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  String erro = "";
  String mensagem = "";

  @override
  void initState() {
    super.initState();
    importarUsuariosDaAPI();
  }

  Future<void> importarUsuariosDaAPI() async {
    QuerySnapshot totalUsuarios = await FirebaseFirestore.instance
        .collection("usuarios")
        .get();

    if (totalUsuarios.size >= 7) return; // Já importou antes

    var url = Uri.parse("https://jsonplaceholder.typicode.com/users");
    var resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      List lista = json.decode(resposta.body);

      for (int i = 0; i < 7; i++) {
        var usuario = lista[i];
        await FirebaseFirestore.instance.collection("usuarios").add({
          "nome": usuario["name"],
          "email": usuario["email"],
          "senha": "123", // senha padrão para todos
        });
      }

      print("Usuários importados para o Firebase!");
    }
  }

  Future<void> FazerLogin() async {
    String email = emailController.text.trim();
    String senha = senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      setState(() {
        mensagem = "Preencha todos os campos";
      });
      return;
    }

    QuerySnapshot usuario = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('email', isEqualTo: email)
        .where('senha', isEqualTo: senha)
        .get();

    if (usuario.docs.isNotEmpty) {
      var dados = usuario.docs.first.data() as Map<String, dynamic>;
      String nomeUsuario = dados["nome"];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NavBar(nomeUsuario: nomeUsuario),
        ),
      );
    } else {
      setState(() {
        erro = "email ou senha incorretos";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          height: 600,
          decoration: BoxDecoration(
            color: const Color(0xFFF2E4EB),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset('assets/img/logo.png', width: 200)),
              const SizedBox(height: 40),

              const Text("Email"),
              const SizedBox(height: 5),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "seu@email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text("Senha"),
              const SizedBox(height: 5),

              TextField(
                controller: senhaController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "•••••",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    FazerLogin();
                  },
                  child: const Text(
                    "Entrar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text("$erro", style: TextStyle(color: Colors.red)),
              Text("$mensagem", style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
