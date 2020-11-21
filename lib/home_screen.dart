import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
// import 'userobject.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:firebase_auth/firebase_auth.dart' as fir; 
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> logOut()async{
    await googleSignIn.signOut();
  }

  // TODO get request to rebuild twitter profile
  // https://firebase.google.com/docs/reference/android/com/google/firebase/auth/TwitterAuthProvider
  // https://firebase.google.com/docs/admin/setup
  // needs twitter auth sdk
  Future<void> getUserProfile() async {
    // TODO send firebase auth token to backend for verification
    // TODO use backend golang library for getting authorized user lookup
    // POST backend -data session_object
    var tok = await widget.user.getIdToken();
    print("FIREBASE TOKEN $tok");
    String userUrl = "http://localhost:5000/signin";// http://localhost:5000/signin
    var _data = {
      "fire_token": tok,
      "twtoken":widget.accessToken,
      "twsecret": widget.accessSecret,
      "uid": int.parse(widget.userId),
      "uname": widget.userName,
      // "consumer_token":"",
      // "consumer_secret":""
    };
    var response = await dio.Dio().post(userUrl,data:_data);
    // var userString = convert.jsonDecode(response.data);

    if(response.statusCode == 200){
      print("USER PROFILE DETAILS${response.data}");
      // var user = UserObject();
      // return user;
    }
    // return UserObject();
      print("SIGN IN${response.data}");
  }

  Widget buildProfile(){
    return FutureBuilder<void>(
      future: getUserProfile(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        var user = snapshot.data;
      print("USER PROFILE DETAILS ${snapshot.data}");
        if(snapshot.hasData){
          return Container(
            decoration: BoxDecoration(color: Colors.blueAccent),
            // child: Text("Login success", style: TextStyle(color: Colors.white))
            child: Text(user.name)
          );
        }
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.greenAccent),
          child: Text("Login success", style: TextStyle(color: Colors.white))
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
      body: Center(
        child: buildProfile()
      )
    );
  }
}