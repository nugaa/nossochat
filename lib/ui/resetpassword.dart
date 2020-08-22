import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nossochat/customs/customFields.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _emailController = new TextEditingController();
  final formKey = GlobalKey<FormState>();

  recuperarPassword(){

    if(formKey.currentState.validate()){
      FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      _emailController.clear();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white24,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("assets/chat.png",
                width: 250,
                height: 250,),
            ),
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 100, left: 8, right: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)
                    ),
                  color: Colors.black38,
                ),
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: <Widget>[
                      Text("Insira o seu email abaixo, iremos enviar um mail com um link de recuperação.",
                      style: textFieldStyle(),
                      ),
                      TextFormField(
                        controller: _emailController,
                        validator: (val) =>
                        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)
                            ? null : "Por favor, insira um email correto",
                      style: textFieldStyle(),
                      decoration: textFieldCustom("Insira o seu email", "Email")),
                      SizedBox(height: 20,),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                        child: FlatButton(
                          color: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.blue, width: 1, style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(50)),
                          child: Text("Recuperar", style: botaoTextStyle(Colors.white)),
                          onPressed: (){
                            recuperarPassword();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              ),
          ],
        ),
      )
    );
  }
}
