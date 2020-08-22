import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

obterUserPorUsername(String username) async{
  
  return await Firestore.instance.collection('utilizadores')
      .where('nome', isGreaterThanOrEqualTo: username.substring(0,1).toUpperCase())
      .getDocuments();
}

obterUserPorEmail(String email) async{
  return await Firestore.instance.collection('utilizadores')
      .where('email', isEqualTo: email)
      .getDocuments();
}

uploadUserInfo(userMap){
  Firestore firestore = Firestore.instance;
  firestore.collection('utilizadores')
      .add(userMap);
}

criarSalaChat(String salachatid, salaChatMapa){
  Firestore.instance.collection('SalaChat')
      .document(salachatid)
      .setData(salaChatMapa)
      .catchError((e){
        print((e.toString()));
  });
}

enviarMensagensParaSala(String salaID, mapaMensagem){
  Firestore.instance.collection('SalaChat')
  .document(salaID).collection('mensagem').add(mapaMensagem)
  .catchError((e){
    print("Erro em enviarMensagensParaSala: ${e.toString()}");
  });
}

obterSalaMensagens(String salaID) async{
  return await Firestore.instance.collection('SalaChat')
      .document(salaID)
      .collection('mensagem')
      .orderBy('hora', descending: false)
      .snapshots();
}

obterSalasChat(String username) async{
  return await Firestore.instance
      .collection('SalaChat')
      .where('users', arrayContains: username)
      .snapshots();
}
}