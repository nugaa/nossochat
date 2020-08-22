import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nossochat/customs/customFields.dart';
import 'package:nossochat/helper/constantes.dart';
import 'package:nossochat/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalaMensagens extends StatefulWidget {

  final String salaID;
  SalaMensagens(this.salaID);

  @override
  _SalaMensagensState createState() => _SalaMensagensState();
}

class _SalaMensagensState extends State<SalaMensagens> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController mensagemController = new TextEditingController();
  String salaMensagemString;

  Stream salaMensagensStream;

  Widget mensagensLista(){
    return StreamBuilder(
      stream: salaMensagensStream,
      builder:(context, snapshot){
        if (snapshot.data == null) return Center(child:CircularProgressIndicator());
        return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, posicao){
              return MensagensTile(
                  snapshot.data.documents[posicao].data["mensagem"],
                  snapshot.data.documents[posicao].data["enviadopor"] == Constantes.meuNome);
            }
        );
      },
    );
  }

  enviarMensagem(){

    if (mensagemController.text.isNotEmpty){
      Map<String, dynamic> mapaMensagem = {
        'mensagem' : mensagemController.text,
        'enviadopor' : Constantes.meuNome,
        'hora' : DateTime.now().millisecondsSinceEpoch
      };

      databaseMethods.enviarMensagensParaSala(widget.salaID, mapaMensagem);
      String mensagem = mapaMensagem[0];
      print(mensagem);
    }
  }

  passarMensagem(String mensagem) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('mensagempassar', mensagem);
  }
  
  @override
  void initState() {
    databaseMethods.obterSalaMensagens(widget.salaID).then((value){
      setState(() {
        salaMensagensStream = value;

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mensagens"),
        centerTitle: true,
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            mensagensLista(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: mensagemController,
                        style: textFieldStyle(),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            hintText: "Mensagem...",
                            hintStyle: TextStyle(
                                color: Colors.white
                            ),
                            border: InputBorder.none,
                            suffixIcon: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.blueAccent[600],
                              child: IconButton(
                                icon: Icon(
                                  Icons.send,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  enviarMensagem();
                                  mensagemController.clear();
                                },
                              ),
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class MensagensTile extends StatelessWidget {

  final String mensagem;
  final bool enviadoPorMim;
  MensagensTile(this.mensagem, this.enviadoPorMim);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: MediaQuery.of(context).size.width,
      alignment: enviadoPorMim ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: enviadoPorMim ? [
            const Color(0xff007EF4),
            const Color(0xff2A75BC)
            ] :
            [
            const Color(0x1AFFFFFF),
            const Color(0x1AFFFFFF)
            ],
          ),
          borderRadius: enviadoPorMim ?
              BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30)
              ) :
              BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30)
              )
        ),
        child: Text(mensagem,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                )),

      ),
    );
  }
}

