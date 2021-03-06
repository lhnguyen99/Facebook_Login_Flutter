import 'package:facebook_login/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class AuthBloc {
  final authService = AuthService();
  final fb = FacebookLogin();

  Stream<User> get currentUser => authService.currentUser;

  loginFacebook() async {
    print('Starting Facebook Login');

    final res = await fb.logIn(
      permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
        // FacebookPermission.userAboutMe,
        // FacebookPermission.userPhotos
      ]
    );

    switch(res.status){
      case FacebookLoginStatus.Success:
      print('It worked');

      //Get Token
      final FacebookAccessToken fbToken = res.accessToken;

      //Convert to Auth Credential
      final AuthCredential credential
        = FacebookAuthProvider.credential(fbToken.token);

      //User Credential to Sign in with Firebase
      final result = await authService.signInWithCredentail(credential);

      print('${result.user.displayName} is now logged in');
      print('${result.user.email} is now logged in');
      print('${result.user.phoneNumber} is now logged in');
      print('${result.user.emailVerified} emailVerified');




      break;
      case FacebookLoginStatus.Cancel:
      print('The user canceled the login');
      break;
      case FacebookLoginStatus.Error:
      print('There was an error');
      break;
    }
  }

  logout(){
    authService.logout();
  }
}