import 'package:flutter/material.dart';
import 'package:nossochat/ui/criarutilizador.dart';
import 'package:nossochat/ui/loginScreen.dart';

class Autenticar extends StatefulWidget {
  @override
  _AutenticarState createState() => _AutenticarState();
}

class _AutenticarState extends State<Autenticar> {

  bool mostrarSignIn = true;

  void toggleView(){
    setState(() {
      mostrarSignIn = !mostrarSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return mostrarSignIn ?
    LoginScreen() : CriarUtilizador();
  }
}
