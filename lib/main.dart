import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth; 
import 'package:firebase_core/firebase_core.dart';
import 'package:auth_social/Module/Login/login_view.dart';
import 'package:auth_social/home_screen.dart';

void main() async {
  // TODO ServicesBinding.defaultBinaryMessenger was accessed before the binding was initialized.
  // TODO No Firebase App '[DEFAULT]' has been created - call Firebase.initializeApp()
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
            primarySwatch: Colors.indigo
        ),
        home: new LoginPage()
    )
);
}

class LoginPage extends StatelessWidget{

    var _auth = auth.FirebaseAuth.instance;

  // Create a credential from the access token
  // final AuthCredential twitterAuthCredential =
  //   TwitterAuthProvider.credential(accessToken: token, secret: secret);
  // Once signed in, return the UserCredential
  // UserCredential user = await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential); 

  // TODO test firebase auth using anonymous
  // https://github.com/asadakber/coffe_app/blob/master/lib/services/auth.dart
  Future<auth.User> signInAnom() async {
    try {

      var result = await _auth.signInAnonymously();
      var user = result.user;
      return _userFromFirebaseUser(user);

    } catch(e) {
        print(e.toString());
        return null;
    }
  }
  auth.User _userFromFirebaseUser(auth.User user) {
    print(user.uid);
    return user;
  }

  // auth change user stream
  Stream<auth.User> get user {
    return _auth.onAuthStateChanged
        //.map((FirebaseUser user) => _userFromFirebaseUser(user));
    .map(_userFromFirebaseUser);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Firebase auth", style: TextStyle(color: Colors.amber))),
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          FlutterLogo(size: 150),
          SizedBox(height:50),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.lightBlue[300]),
            child: GestureDetector(
              onTap: (){
                signInAnom().then((user) => 
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => HomeScreen(user: user)))
                );
                // loginTwitter().then((user) =>
                // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen())));
              },
              child: Text("Login with Twitter", style: TextStyle(color: Colors.white))
            )
          )
        ],)
      ),
    );
  }
}