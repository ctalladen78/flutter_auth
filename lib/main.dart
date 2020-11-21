import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fir; 
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  final fir.FirebaseAuth _firauth = fir.FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  LoginPage(){
    checkSession();
  }

  void checkSession() async {

  }


  Future<fir.User> signInSocial() async{
    // Create a credential from the access token
    // final AuthCredential twitterAuthCredential =
    //   TwitterAuthProvider.credential(accessToken: token, secret: secret);
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final fir.AuthCredential _credential = fir.GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    //Firebaseのuser id取得
    final fir.User user = (await _firauth.signInWithCredential(_credential)).user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final fir.User currentUser = _firauth.currentUser;
      assert(user.uid == currentUser.uid);

      // var firtok1 = _credential.token; // auth_credential
      return _userFromFirebaseUser(user);
    }
    return null;
  }

  // TODO test firebase auth using anonymous
  // https://github.com/asadakber/coffe_app/blob/master/lib/services/auth.dart
  Future<fir.User> signInAnom() async {
    try {

      var result = await _firauth.signInAnonymously();
      fir.User user = result.user;
      return _userFromFirebaseUser(user);

    } catch(e) {
        print(e.toString());
        return null;
    }
  }

  fir.User _userFromFirebaseUser(fir.User user) {
    print(user.uid);
    return user;
  }

  // auth response changes user stream
  Stream<fir.User> get _user {
    return _firauth.onAuthStateChanged
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
              color: Colors.amber),
            child: GestureDetector(
              onTap: (){
                signInAnom().then((user) => 
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => HomeScreen(user: user)))
                );
              },
              child: Text("Login Anonymous", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))
            )
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.lightBlue[300]),
            child: GestureDetector(
              onTap: (){
                signInSocial().then((user) =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(user:user)))
                );
              },
              child: Text("Login with Twitter", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))
            )
          )
        ],)
      ),
    );
  }
}