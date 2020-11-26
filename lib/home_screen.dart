import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
// import 'userobject.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:firebase_auth/firebase_auth.dart' as fir; 
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'main.dart';

class HomeScreen extends StatefulWidget {
  String accessToken;
  String accessSecret;
  String userId;
  String userName;
  fir.User user;
  HomeScreen({Key key,this.userName, this.userId,this.accessToken,this.accessSecret, this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/**
flutter: LOGIN SUCCESS USERID 1478875920
flutter: LOGIN SUCCESS USERNAME 1478875920
flutter: LOGIN SUCCESS TOKEN 1478875920-gLQ8eDKJoaA3lDayDLhDQXO0vAfNhOhW98uBKqW
flutter: LOGIN SUCCESS SECRET 3jnN6YZwu5QCQL7xCjOzlXFIE6q4PJrGVon4VLyc0EjIU
 */
class _HomeScreenState extends State<HomeScreen> {

  final fir.FirebaseAuth _firauth = fir.FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final facebookLogin = FacebookLogin();

  Future<void> logOut()async{
    await googleSignIn.signOut();
  }

  // TODO get request to rebuild twitter profile
  // https://firebase.google.com/docs/reference/android/com/google/firebase/auth/TwitterAuthProvider
  // https://firebase.google.com/docs/admin/setup
  // needs twitter auth sdk
  Future<Map<String,dynamic>> getUserProfile() async {
    // TODO send firebase auth token to backend for verification
    // TODO use backend golang library for getting authorized user lookup
    // POST backend -data session_object
    var tok = await widget.user.getIdToken();
    print("FIREBASE TOKEN $tok");
    String userUrl = "http://localhost:5000/signin";// http://localhost:5000/signin
    var _data = {
      "fire_token": tok,
    };
    var response = await dio.Dio().post(userUrl,data:_data);
    // var userString = convert.jsonDecode(response.data);

    if(response.statusCode == 200){
      print("SIGN IN${response.data}");
      print("DISPLAY NAME ${widget.user.displayName}");
      print("EMAIL ${widget.user.email}");
      print("AVATAR ${widget.user.photoURL}");
      return {
        "name": widget.user.displayName,
        "email": widget.user.email,
        "avatar": widget.user.photoURL,
      };
    }
    return null;
  }

  Widget buildProfile(){
    return FutureBuilder<Map<String,dynamic>>(
      future: getUserProfile(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        var userMap = snapshot.data;
      print("USER PROFILE DETAILS ${snapshot.data}");
        if(snapshot.hasData){
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.blue[50]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                  CircleAvatar(
                    backgroundImage: NetworkImage(userMap["avatar"]),
                  ),
                  Text(userMap["name"]),
                  SizedBox(height:10),
                  Text(userMap["email"])
                ]),)
              ],
            )
          );
        }
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.greenAccent),
          child: Column(children:[
            Text("Login success", style: TextStyle(color: Colors.white)),
            SizedBox(height: 50),
            GestureDetector(
              onTap: () async {
                await googleSignIn.signOut();
                await facebookLogin.logOut();
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> LoginPage()));
              },
              child: Text("Log out", style: TextStyle(color: Colors.white))
            )
          ])
        );
      }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    // getUserProfile();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildProfile()
    );
  }
}