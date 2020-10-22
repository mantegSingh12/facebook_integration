import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'homePage.dart';
import 'package:facebook_integration/blocs/facebookAuth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => FacebookAuth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyLogInPage(),
      ),
    );
  }
}

class MyLogInPage extends StatefulWidget {
  @override
  _MyLogInPageState createState() => _MyLogInPageState();
}

class _MyLogInPageState extends State<MyLogInPage> {
  StreamSubscription<User> logInStateSubscription;
  bool isLoading = false;

  @override
  void initState() {
    var fbBloc = Provider.of<FacebookAuth>(context, listen: false);
    logInStateSubscription = fbBloc.currentUSer.listen(
      (fbUser) {
        if (fbUser != null) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()));
          isLoading = false;
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    logInStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var fbAuthBloc = Provider.of<FacebookAuth>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Facebook Authentication'),
        ),
        body: Center(
          child: Container(
            child: Center(
              child: isLoading
                  ? CircularProgressIndicator()
                  : OutlineButton(
                      splashColor: Colors.grey,
                      onPressed: () {
                        fbAuthBloc.signInWithFacebook();
                        setState(() {
                          isLoading = true;
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      highlightElevation: 0,
                      borderSide: BorderSide(color: Colors.blue[900]),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Image(
                                image: AssetImage("assets/fb_logo.png"),
                                height: 35.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: const Text(
                                'Sign in with Facebook',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ));
  }
}
