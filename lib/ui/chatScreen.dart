import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nossochat/customs/customFields.dart';
import 'package:nossochat/helper/autenticar.dart';
import 'package:nossochat/helper/constantes.dart';
import 'package:nossochat/helper/helperfunctions.dart';
import 'package:nossochat/services/auth.dart';
import 'package:nossochat/services/database.dart';
import 'package:nossochat/ui/procurar.dart';
import 'package:nossochat/ui/salamensagens.dart';

class ChatScreen extends StatefulWidget {

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream salasChatStream;

  Widget salaChatLista(){
    return StreamBuilder(
      stream: salasChatStream,
      builder: (context, snapshot){
        if (snapshot.data == null) return Center(child:CircularProgressIndicator());
        return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, posicao){
              return ListaSalasChatTile(
                  snapshot.data.documents[posicao].data['salachatid']
                      .toString().replaceAll("_", " ")
                      .replaceAll(Constantes.meuNome, ""),
                  snapshot.data.documents[posicao].data['salachatid'],
              );
            }
        );
      }
    );
  }

  @override
  void initState() {
    obterUserInfo();
    super.initState();
  }

  obterUserInfo() async{
    Constantes.meuNome = await HelperFunctions.getUserName();
    setState(() {
      databaseMethods.obterSalasChat(Constantes.meuNome).then((val){
        setState(() {
          salasChatStream = val;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sala de Chats"),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: (){
                authMethods.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => Autenticar()
                ));
              },
            ),
          )
        ],
      ),
      body: salaChatLista(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context)=> Procurar()
          )
          );
        },
      ),
    );
  }
}

class ListaSalasChatTile extends StatelessWidget {

  final String username;
  final String salaID;
  ListaSalasChatTile(this.username, this.salaID);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => SalaMensagens(salaID)
        ));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30)
        ),
        elevation: 5,
        shadowColor: Colors.white54,
        color: Colors.white24,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Text(username.substring(0,1).replaceAll(" ", username.substring(1,2)), style: textFieldStyle(),),
          ),
          title: Text(username)
        ),
      ),
    );
  }
}


