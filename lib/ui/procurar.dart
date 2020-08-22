import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nossochat/customs/customFields.dart';
import 'package:nossochat/helper/constantes.dart';
import 'package:nossochat/services/database.dart';
import 'package:nossochat/ui/salamensagens.dart';

class Procurar extends StatefulWidget {
  @override
  _ProcurarState createState() => _ProcurarState();
}
class _ProcurarState extends State<Procurar> {

  TextEditingController _procura = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  QuerySnapshot procurarSnapshot;

  Widget listaProcura() {
    //TODO SE _procura.toString().isEmpty lista.clear()
      return procurarSnapshot != null ?
      ListView.builder(
          itemCount: procurarSnapshot.documents.length,
          shrinkWrap: true,
          itemBuilder: (_, posicao) {
            return procuraTile(
              userName: procurarSnapshot.documents[posicao].data['nome'],
              userEmail: procurarSnapshot.documents[posicao].data['email'],
            );
          }
      ) : Container(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: ListTile(
              leading: Icon(Icons.search),
              title: Text('Lista está vazia'),
            )
          ),
        ),
      );
  }

  iniciarProcura(String procura) {
    //TODO PESQUISA PELO NOME SE COMEÇAR POR x E TERMINAR POR x, MOSTRAR
    
    databaseMethods
        .obterUserPorUsername(procura)
        .then((val){
          setState(() {
            procurarSnapshot = val;
          });
    });

  }

  criarSalaChat({String username}) {

    if (username  != Constantes.meuNome) {
      String salaID = obterChatRoomId(username, Constantes.meuNome);

      List<String> users = [username, Constantes.meuNome];

      Map<String, dynamic> chatRoomMap = {
        'users': users,
        'salachatid': salaID
      };

      DatabaseMethods().criarSalaChat(salaID, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => SalaMensagens(salaID)
      ));
    }else{
      print("Não podes enviar mensagens para ti mesmo");
    }
  }

  Widget procuraTile({String userName, String userEmail}) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(userName,
                    style: textFieldStyle(),
                  ),
                  Text(userEmail, style: TextStyle(
                    color: Colors.white24,
                    fontSize: 14,
                  ),)
                ],
              ),
              Spacer(),
              IconButton(
                icon: CircleAvatar(
                  backgroundColor: Colors.white12,
                  child: Icon(
                      Icons.message,
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  criarSalaChat(username: userName);
                },
              )
            ]
        ),
      ),
    );
  }

  _printUltimoValor(){
    print("${_procura.text}");}

  @override
  void initState() {
    super.initState();
    _procura.addListener(() => _printUltimoValor());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Procurar"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _procura,
                        style: textFieldStyle(),
                        decoration: InputDecoration(
                            hintText: "Procurar por nome...",
                            hintStyle: TextStyle(
                                color: Colors.white
                            ),
                            border: InputBorder.none,
                            suffixIcon: CircleAvatar(
                              backgroundColor: Colors.white24,
                              child: IconButton(
                                icon: Icon(
                                  Icons.search,
                                  size: 35,
                                  color: Colors.blueAccent[800],
                                ),
                                onPressed: () {
                                  iniciarProcura(_procura.text);
                                },
                              ),
                            )
                        ),
                        onChanged: (text){
                          iniciarProcura(text);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              listaProcura(),
            ],
          ),
        ),
      ),
    );
  }
}


obterChatRoomId(String a, String b){
  if (a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
    return"$b\_$a";
  }else{
    return "$a\_$b";
  }
}
