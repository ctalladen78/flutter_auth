import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fir; 
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:auth_social/Module/Login/login_view.dart';
import 'package:auth_social/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final fir.FirebaseAuth _firauth = fir.FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final facebookLogin = FacebookLogin();

  @override
  void initState() { 
    super.initState();
    checkSession().then((user) => {
      if(user != null){
        Navigator.push(context, 
          MaterialPageRoute(builder: (context) => HomeScreen(user: user)))
      }
    });
  }


  Future<fir.User> checkSession() async {
    // check connectivity
    bool isUserSignedIn = await googleSignIn.isSignedIn();
    if(isUserSignedIn && _firauth.currentUser != null){
      return _firauth.currentUser;
    }
    return null;
  }

  Future<fir.User> signInFB() async{
    String fbredirectURL = "https://www.facebook.com/connect/login_success.html";
    String fbapi = "";
    String fbloginURL = "https://www.facebook.com/dialog/oauth?client_id=$fbapi&redirect_uri=$fbredirectURL&response_type=token&scope=email,public_profile";
    fir.AuthCredential _credential;
    fir.User user;

    FacebookLoginResult result = await facebookLogin.logIn(['email']); 
    // final FacebookLoginResult result = await FacebookAuth.instance.login();
    // final FacebookLoginResult result = await facebookLogin.loginWithReadPermissions(['email']);
    
    if (result.accessToken != null) { 
      try { 
        _credential = fir.FacebookAuthProvider.credential(result.accessToken.token); 
        // fir.UserCredential authResult = await _firauth.signInWithCredential(credential);
        // fir.User user = authResult.user; print(user); 
        //Firebaseのuser id取得
        user = (await _firauth.signInWithCredential(_credential)).user;
      } catch (err) { print("FB SIGNIN ERROR $err"); } 
    } 

    // Create a credential from the access token
    // fir.FacebookAuthProvider.FACEBOOK_SIGN_IN_METHOD
    // fir.FacebookAuthProvider.PROVIDER_ID
    // final fir.FacebookAuthCredential _credential = fir.FacebookAuthProvider.credential(
    //   accessToken:
    // );

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final fir.User currentUser = _firauth.currentUser;
      print("CURRENT USER ${currentUser.uid}");
      print("SIGNEDIN USER ${user.uid}");
      // assert(user.uid == currentUser.uid);

      // var firtok1 = _credential.token; // auth_credential
      // TODO save user info
      var uid = user.uid;
      var email = user.email;
      var avatar = user.photoURL;
      var name = user.displayName;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('fir_uid',uid);
      prefs.setString('fir_email',email);
      prefs.setString('fir_avatar',avatar);
      prefs.setString('fir_name',name);
      return _userFromFirebaseUser(user);
    }
    return null;
  }

  // final AuthCredential twitterAuthCredential =
  //   TwitterAuthProvider.credential(accessToken: token, secret: secret);
  Future<fir.User> signInGoogle() async{
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    // Create a credential from the access token
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
      print("CURRENT USER ${currentUser.uid}");
      print("SIGNEDIN USER ${user.uid}");
      // assert(user.uid == currentUser.uid);

      // var firtok1 = _credential.token; // auth_credential
      // TODO save user info
      var uid = user.uid;
      var email = user.email;
      var avatar = user.photoURL;
      var name = user.displayName;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('fir_uid',uid);
      prefs.setString('fir_email',email);
      prefs.setString('fir_avatar',avatar);
      prefs.setString('fir_name',name);
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
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.lightBlue[300]),
            child: GestureDetector(
              onTap: (){
                signInGoogle().then((user) =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(user:user)))
                );
              },
              child: Text("Login with Twitter", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))
            )
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.indigo),
            child: GestureDetector(
              onTap: (){
                signInFB().then((user) => 
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => HomeScreen(user: user)))
                );
              },
              child: Text("Login Facebook", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))
            )
          ),
        ],)
      ),
    );
  }
}