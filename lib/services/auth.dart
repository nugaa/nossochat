import 'package:firebase_auth/firebase_auth.dart';
import 'package:nossochat/modelos/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthResultStatus {
  successful,
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  undefined,
}

class AuthExceptionHandler {
  static handleException(e) {
    print(e.code);
    var status;
    switch (e.code) {
      case "ERROR_INVALID_EMAIL":
        status = AuthResultStatus.invalidEmail;
        break;
      case "ERROR_WRONG_PASSWORD":
        status = AuthResultStatus.wrongPassword;
        break;
      case "ERROR_USER_NOT_FOUND":
        status = AuthResultStatus.userNotFound;
        break;
      case "ERROR_USER_DISABLED":
        status = AuthResultStatus.userDisabled;
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        status = AuthResultStatus.tooManyRequests;
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        status = AuthResultStatus.operationNotAllowed;
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        status = AuthResultStatus.emailAlreadyExists;
        break;
      default:
        status = AuthResultStatus.undefined;
    }
    return status;
  }

  ///
  /// Accepts AuthExceptionHandler.errorType
  ///
  static generateExceptionMessage(exceptionCode) {
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = "Endereço de email inválido";
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = "A password inserida está incorreta";
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = "Conta com este email não existe";
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = "Conta com este email foi desabilitada.";
        break;
      case AuthResultStatus.tooManyRequests:
        errorMessage = "Demasiados pedidos, tente novamente mais tarde.";
        break;
      case AuthResultStatus.operationNotAllowed:
        errorMessage = "Operação não permitida.";
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage =
        "Conta com este email já existe, por favor faça login ou recupere a sua password.";
        break;
      default:
        errorMessage = "An undefined Error happened.";
    }

    return errorMessage;
  }
}

class AuthMethods{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  AuthResultStatus _status;

  User _userFirebaseUser(FirebaseUser user){
    return user != null ? User(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async{

    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (result.user != null){
        _status = AuthResultStatus.successful;
      }else{
        _status = AuthResultStatus.undefined;
      }

//      FirebaseUser firebaseUser = result.user;
//
//      return _userFirebaseUser(firebaseUser);

    }catch(e){
      print('Exceção @entrarConta: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  Future signUpWithEmailAndPassword(String email, String password) async{
    FirebaseUser user;

    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if(result.user != null){
        _status = AuthResultStatus.successful;
      }else{
        _status = AuthResultStatus.undefined;
      }
//      FirebaseUser firebaseUser = result.user;
//      return _userFirebaseUser(firebaseUser);
    }catch(e){
      print('Exceção @criarConta: $e');
      _status = AuthExceptionHandler.handleException(e);
      }
      return _status;
  }


  Future resetPassword(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
    }
  }
  
  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }

  Future googleSignIn() async{
    FirebaseUser _user;
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    try {
      AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      
      AuthResult result = (await _auth.signInWithCredential(credential));
      
      _user = result.user;
      return _userFirebaseUser(_user);

    } on Exception catch (e) {
      print("Erro ao entrar com conta Google: ${e.toString()}");
    }
  }

  Future googleSignOut() async{
    await _auth.signOut().then((value){
      _googleSignIn.signOut();
    });
  }

}