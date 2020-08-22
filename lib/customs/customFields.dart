import 'package:flutter/material.dart';

InputDecoration textFieldCustom(String textHint, String labelText) {
  return InputDecoration(
      hintText: textHint,
      labelText: labelText,
      labelStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
      hintStyle: TextStyle(color: Colors.white54),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
}

TextStyle textFieldStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 16,
  );
}

TextStyle botaoTextStyle(Color cor) {
  return TextStyle(
    color: cor,
    fontSize: 18,
    fontWeight: FontWeight.w700
  );
}

Container customContainer(BuildContext context, List<Color> cores, String texto, Color corTexto) {
  return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: cores,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        texto,
        style: botaoTextStyle(corTexto),
      ));
}
