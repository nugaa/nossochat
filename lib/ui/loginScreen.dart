import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nossochat/customs/customFields.dart';
import 'package:nossochat/helper/helperfunctions.dart';
import 'package:nossochat/services/auth.dart';
import 'package:nossochat/services/database.dart';
import 'package:nossochat/ui/chatScreen.dart';
import 'package:nossochat/ui/criarutilizador.dart';
import 'package:nossochat/ui/resetpassword.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthMethods _authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController _emailTextController = new TextEditingController();
  TextEditingController _passwordTextController = new TextEditingController();
  TextEditingController _usernameTextController = new TextEditingController();
  final formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String erroPass;

  bool aCarregar = false;
  QuerySnapshot snapshotUserInfo;

  entrar() async {
    if (formKey.currentState.validate()) {
      HelperFunctions.salvarUserEmail(_emailTextController.text.trim());

      databaseMethods
          .obterUserPorEmail(_emailTextController.text.trim())
          .then((val) {
        snapshotUserInfo = val;
        HelperFunctions.salvarUserName(
            snapshotUserInfo.documents[0].data['nome']);
      });

      setState(() {
        aCarregar = true;
      });
      final status = await _authMethods
          .signInWithEmailAndPassword(
          _emailTextController.text.trim(), _passwordTextController.text);

        if (status == AuthResultStatus.successful) {
          HelperFunctions.salvarUserLogged(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatScreen()));
        } else {
          final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.grey[800],
                  title: Text("Erro...", style: textFieldStyle(),),
                  content: Text(errorMsg, style: textFieldStyle(),),
                  actions: <Widget>[
                    Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: 50,
                        child: FlatButton(
                          color: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.blue,
                                  width: 1,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                              "OK", style: botaoTextStyle(Colors.white)),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                    )
                  ],
                );
              });
        }
    }
  }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text("NossoChat"),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Image.asset(
                      "assets/chat.png",
                      width: 200,
                      height: 200,
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                            validator: (val) =>
                            RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val)
                                ? null
                                : "Por favor, insira um email correto",
                            controller: _emailTextController,
                            style: textFieldStyle(),
                            decoration:
                            textFieldCustom("Insira o seu email", "Email")),
                        TextFormField(
                            validator: (val) =>
                            val.length >= 6
                                ? null
                                : "Password tem que ter 6 ou mais caratéres.",
                            controller: _passwordTextController,
                            obscureText: true,
                            style: textFieldStyle(),
                            decoration: textFieldCustom(
                                "Insira aqui a sua password", "Password")),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => ResetPassword()));
                    },
                    child: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(
                          "Esqueceu a sua password?",
                          style: textFieldStyle(),
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 60,
                    child: FlatButton(
                      child: Text(
                          "Entrar", style: botaoTextStyle(Colors.white)),
                      color: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.blue,
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(50)),
                      onPressed: () {
                        entrar();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 60,
                    child: FlatButton(
                      splashColor: Colors.black54,
                      child: Text("Entrar com conta Google",
                          style: botaoTextStyle(Colors.black)),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.white,
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(50)),
                      onPressed: () {
                        _authMethods.googleSignIn().then((value) {
                          if (value != null) {
                            mostrarDialogBox();
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Ainda não tem conta? ",
                        style: textFieldStyle(),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CriarUtilizador()));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "Criar conta.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }

      mostrarDialogBox() {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.grey[800],
                title: Text("Criar username", style: textFieldStyle(),),
                content:
                TextField(
                  controller: _usernameTextController,
                  style: textFieldStyle(),
                  decoration:
                  textFieldCustom("Seu nome de conta", "Nome de utilizador"),
                ),
                actions: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 50,
                    child: FlatButton(
                      color: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.blue,
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                          "Criar Conta", style: botaoTextStyle(Colors.white)),
                      onPressed: () async {
                        FirebaseUser user = await FirebaseAuth.instance
                            .currentUser();

                        if (user != null) {
                          String email = user.email.toString();
                          print("O email é: $email");

                          if (_usernameTextController.text.isEmpty ||
                              _usernameTextController.text.length < 3) {
                            SnackBar snack = new
                            SnackBar(content: Text(
                                "Insira um nome de utilizador, maior que 3 caractéres."),
                              duration: Duration(seconds: 5),
                            );
                            _scaffoldKey.currentState.showSnackBar(snack);
                          } else {
                            HelperFunctions.salvarUserEmail(email);
                            HelperFunctions.salvarUserName(
                                _usernameTextController.text.trim());


                            Map<String, dynamic> userInfoMap = {
                              'nome': _usernameTextController.text.trim(),
                              'email': email,
                            };

                            databaseMethods.uploadUserInfo(userInfoMap);
                            HelperFunctions.salvarUserLogged(true);
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen()));
                          }
                        } else {
                          SnackBar snackError = new
                          SnackBar(content: Text(
                              "Não existe nenhum utilizador logado de momento."),
                            duration: Duration(seconds: 5),
                          );
                          _scaffoldKey.currentState.showSnackBar(snackError);
                        }
                      },
                    ),
                  )
                ],
              );
            });
  }
}
