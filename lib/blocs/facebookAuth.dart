import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:facebook_integration/authService/authService.dart';

class FacebookAuth {
  final authService = AuthService();
  final fbLogin = FacebookLogin();

  Stream<User> get currentUSer => authService.currentUser;

  signInWithFacebook() async {
    final res = await fbLogin.logIn(['email', 'public_profile']);

    switch (res.status) {
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        break;
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken fbAccessToken = res.accessToken;
        final AuthCredential authCredential =
            FacebookAuthProvider.credential(fbAccessToken.token);
        final result = authService.signInWithCredential(authCredential);
        result.then((user) => print(user.user.displayName));
        break;
    }
  }

  void signOut() {
    authService.signOut();
  }
}
