import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //função para inicializar os componentes que utilizam o firebase
  await Firebase.initializeApp(//aguarda o firebase inicializar
    options: DefaultFirebaseOptions.currentPlatform

  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget { //permite a navegação
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage()
    );
  }
}


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            color: Colors.blueAccent,
            child: Padding(padding: const EdgeInsets.all(20.0),
              child: Text("data"),
            ),
          ),
        ),
      ),
    );
   
  }
}  