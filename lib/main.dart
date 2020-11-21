import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fir; 
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
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
  final TwitterLogin twitterLogin = TwitterLogin(
    consumerKey: "IoJiMkAVEmjjkQoIExzAn69xE",
    consumerSecret: "ZCa3waPjr9HM5xHDgSDcLjiGqy6jBeQ6DlVyAa5uOkDG09bLOU",
  );
  // Create a credential from the access token
  // final AuthCredential twitterAuthCredential =
  //   TwitterAuthProvider.credential(accessToken: token, secret: secret);
  // Once signed in, return the UserCredential
  // UserCredential user = await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential); 

  Future<Map<String,dynamic>> signInWithTwitter() async {
    // twitter認証の許可画面が出現
    final TwitterLoginResult result = await twitterLogin.authorize();

    // github.com/maedaouka/kosan-syoumei
    //Firebaseのユーザー情報にアクセス & 情報の登録 & 取得
    // final AuthCredential credential = TwitterAuthProvider.getCredential(
      // authToken: result.session.token,
      // authTokenSecret: result.session.secret,
    fir.AuthCredential _credential;
    if(TwitterLoginStatus.loggedIn == true){
      _credential = fir.TwitterAuthProvider.credential(
        accessToken: result.session.token,
        secret: result.session.secret,
      );
    }

    //Firebaseのuser id取得
    final fir.User user = (await _firauth.signInWithCredential(_credential)).user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    //  final FirebaseUser currentUser = await _auth.currentUser();
    fir.User currentUser =  _firauth.currentUser;
    assert(user.uid == currentUser.uid);

    // login(user, result.session.token, result.session.secret);

    var firtok1 = _credential.token; // auth_credential
    return {
      "user": user,
      "twtoken": result.session.token,
      "twsecret": result.session.secret,
    };
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
  Stream<fir.User> get user {
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
                signInWithTwitter().then((user) =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()))
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