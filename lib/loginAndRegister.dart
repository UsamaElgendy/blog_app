import 'package:blogapp/auth/authintication.dart';
import 'package:blogapp/dialogbox.dart';
import 'package:flutter/material.dart';

class LoginAndRegisterPage extends StatefulWidget {
  final AuthImplementation auth;
  final VoidCallback onSignIn;

  LoginAndRegisterPage({
    this.auth,
    this.onSignIn,
  });

  @override
  _LoginAndRegisterPageState createState() => _LoginAndRegisterPageState();
}

enum FormType {
  login,
  register,
}

class _LoginAndRegisterPageState extends State<LoginAndRegisterPage> {
  DialogBox dialogBox = DialogBox();
  final formKey = GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BlogApp'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: createInput() + createButtons(),
            )),
      ),
    );
  }

  List<Widget> createInput() {
    return [
      SizedBox(
        height: 10.0,
      ),
      logo(),
      SizedBox(
        height: 20.0,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value) {
          return value.isEmpty ? 'Email is require ' : null;
        },
        onSaved: (value) {
          return _email = value;
        },
      ),
      SizedBox(
        height: 10.0,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) {
          return value.isEmpty ? 'Password is require ' : null;
        },
        onSaved: (value) {
          return _password = value;
        },
      ),
      SizedBox(
        height: 20.0,
      ),
    ];
  }

  Widget logo() {
    return Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 110,
        child: Image.asset('images/logo.png'),
      ),
    );
  }

  List<Widget> createButtons() {
    if (_formType == FormType.login) {
      return [
        RaisedButton(
          onPressed: validateAndSubmit,
          child: Text(
            'Login',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          textColor: Colors.white,
          color: Colors.pink,
        ),
        FlatButton(
          onPressed: moveToRegister,
          child: Text(
            'Not have an account? create one',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          textColor: Colors.white,
          color: Colors.red,
        ),
      ];
    } else {
      return [
        RaisedButton(
          onPressed: validateAndSubmit,
          child: Text(
            'Register',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          textColor: Colors.white,
          color: Colors.pink,
        ),
        FlatButton(
          onPressed: moveToLogin,
          child: Text(
            'Already have an account? Login',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          textColor: Colors.white,
          color: Colors.red,
        ),
      ];
    }
  }

  // Methods
  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId = await widget.auth.signIn(_email, _password);
          dialogBox.information(
            context,
            'Congratulation : ',
            'you are logged in  successfully',
          );
          print(userId);
        } else {
          String userId = await widget.auth.signUp(_email, _password);
          dialogBox.information(
            context,
            'Congratulation : ',
            'your account has been created successfully',
          );
          print(userId);
        }
        widget.onSignIn();
      } catch (e) {
        dialogBox.information(context, 'Error: ', e.toString());
        print(e.toString());
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }
}
