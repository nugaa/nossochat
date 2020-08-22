import 'package:flutter/material.dart';
import 'package:nossochat/helper/autenticar.dart';
import 'package:nossochat/helper/helperfunctions.dart';
import 'package:nossochat/ui/chatScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool userLogged = false;

  @override
  void initState() {
    getLoginState();
    super.initState();
  }

  getLoginState() async{
    await HelperFunctions.getUserLogged().then((value){
      setState(() {
        userLogged = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xff145C9E),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: userLogged != null ? ChatScreen() : Autenticar(),
    );
  }
}

