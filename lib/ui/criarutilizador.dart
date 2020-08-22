import 'package:flutter/material.dart';
import 'package:nossochat/customs/customFields.dart';
import 'package:nossochat/helper/helperfunctions.dart';
import 'package:nossochat/services/auth.dart';
import 'package:nossochat/services/database.dart';
import 'package:nossochat/ui/chatScreen.dart';
import 'package:nossochat/ui/loginScreen.dart';

class CriarUtilizador extends StatefulWidget {
  @override
  _CriarUtilizadorState createState() => _CriarUtilizadorState();
}

class _CriarUtilizadorState extends State<CriarUtilizador> {
  TextEditingController _nomeUtilizador = new TextEditingController();
  TextEditingController _emailUtilizador = new TextEditingController();
  TextEditingController _passwordUtilizador = new TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool aCarregar = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  entrarNaConta() async {
    if (formKey.currentState.validate()) {
      setState(() {
        aCarregar = true;
      });

      final status = await authMethods
          .signUpWithEmailAndPassword(
              _emailUtilizador.text, _passwordUtilizador.text);
      if (status == AuthResultStatus.successful){

        Map<String, dynamic> userInfoMap = {
          'nome': _nomeUtilizador.text.trim(),
          'email': _emailUtilizador.text.trim(),
        };

        HelperFunctions.salvarUserEmail(_emailUtilizador.text.trim());
        HelperFunctions.salvarUserName(_nomeUtilizador.text.trim());

        databaseMethods.uploadUserInfo(userInfoMap);

        ///databaseMethods.uploadUserInfo
        //print("${val.uid}");
        HelperFunctions.salvarUserLogged(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatScreen()));

      }else{
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
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                        },
                      )
                  )
                ],
              );
            });
      }

      }
  }

  @override
  void initState() {
    //TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Criar Conta"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white24,
      body: aCarregar
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : Container(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Image.asset(
                          "assets/chat.png",
                          width: 230,
                          height: 230,
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 15, left: 8, right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30)),
                            color: Colors.black38,
                          ),
                          child: Form(
                              key: formKey,
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 20, left: 20, right: 20),
                                  child: Column(children: <Widget>[
                                    TextFormField(
                                        validator: (val) =>
                                            val.isEmpty || val.length < 3
                                                ? "Insira um nome utilzador"
                                                : null,
                                        controller: _nomeUtilizador,
                                        style: textFieldStyle(),
                                        decoration: textFieldCustom(
                                            "Seu nome de conta",
                                            "Nome de utilizador")),
                                    TextFormField(
                                        validator: (val) => RegExp(
                                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                .hasMatch(val)
                                            ? null
                                            : "Por favor, insira um email correto",
                                        controller: _emailUtilizador,
                                        style: textFieldStyle(),
                                        decoration: textFieldCustom(
                                            "Insira o seu email", "Email")),
                                    TextFormField(
                                        obscureText: true,
                                        validator: (val) => val.length >= 6
                                            ? null
                                            : "Password tem que ter 6 ou mais caratéres.",
                                        controller: _passwordUtilizador,
                                        style: textFieldStyle(),
                                        decoration: textFieldCustom(
                                            "Insira aqui a sua password",
                                            "Password")),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 60,
                                      child: FlatButton(
                                        color: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.blue,
                                                width: 1,
                                                style: BorderStyle.solid),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: Text("Criar Conta",
                                            style: botaoTextStyle(Colors.white)),
                                        onPressed: () {
                                          entrarNaConta();
                                        },
                                      ),
                                    )
                                  ]))))
                    ],
                  ),
                ),
              ),
          ),
    );
  }
}
