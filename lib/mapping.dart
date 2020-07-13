import 'package:blogapp/auth/authintication.dart';
import 'package:blogapp/home_page.dart';
import 'package:blogapp/loginAndRegister.dart';
import 'package:flutter/material.dart';

class MappingPage extends StatefulWidget {
  final AuthImplementation auth;

  MappingPage({
    this.auth,
  });

  State<StatefulWidget> createState() {
    return _MappingPageState();
  }
}

enum AuthStatus { noSignIn, signIn }

class _MappingPageState extends State<MappingPage> {
  AuthStatus authStatus = AuthStatus.noSignIn;

  @override
  void initState() {
    super.initState();

    widget.auth.getCurrentUser().then((firebaseUserId) {
      setState(() {
        authStatus =
            firebaseUserId == null ? AuthStatus.noSignIn : AuthStatus.signIn;
      });
    });
  }

  void _signIn() {
    setState(() {
      authStatus = AuthStatus.signIn;
    });
  }

  void _signOut() {
    setState(() {
      authStatus = AuthStatus.noSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.noSignIn:
        return LoginAndRegisterPage(
          auth: widget.auth,
          onSignIn: _signIn,
        );

      case AuthStatus.signIn:
        return HomePage(
          auth: widget.auth,
          onSignOut: _signOut,
        );
    }
    return null;
  }
}
