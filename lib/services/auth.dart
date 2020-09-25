import 'package:coffe_brew_crew/models/user.dart';
import 'package:coffe_brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on firebase user
  UserOfApp _userFromFirebaseUser(User user){
    return (user!=null ? UserOfApp(uid: user.uid) :null); 
  }

  //auth change user stream
  Stream<UserOfApp> get user{
    return _auth.authStateChanges()
      // .map((User user) => _userFromFirebaseUser(user) );
      .map(_userFromFirebaseUser);                        //same line as above
  }


  //sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
      // return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }



  // sign in with email
  Future signInWithEmailPassword(String email,String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }


  //register with email pass
  Future registerWithEmailPassword(String email,String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;

      //create a new document for the user with uid
      await DatabaseService(uid:user.uid).updateUserData('0', 'new crew member', 100 );
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //signout
  Future signOut() async{
    try {
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}