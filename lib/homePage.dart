import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:facebook_integration/blocs/facebookAuth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:facebook_integration/main.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<bool> popUpDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Please Sign Out'),
        actions: <Widget>[
          RaisedButton(
              child: Text('Okay'),
              onPressed: () => Navigator.of(context).pop(false)),
        ],
      ),
    );
  }

  StreamSubscription<User> homeStreamSubscription;
  @override
  void initState() {
    var fbBloc = Provider.of<FacebookAuth>(context, listen: false);
    homeStreamSubscription = fbBloc.currentUSer.listen((fbUser) {
      if (fbUser == null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MyLogInPage()));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    homeStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fbBloc = Provider.of<FacebookAuth>(context);

    return WillPopScope(
      onWillPop: () => popUpDialog(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
        ),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                signInButton(fbBloc),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget signInButton(var fbBloc) {
    return RaisedButton(
      onPressed: () {
        fbBloc.signOut();
      },
      color: Colors.deepPurple,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Sign Out',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    );
  }
}
