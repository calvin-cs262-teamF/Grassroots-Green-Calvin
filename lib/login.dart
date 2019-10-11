import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  static const String routeName = "/login";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: LoginStatefulWidget(),
    );
  }
}

class LoginStatefulWidget extends StatefulWidget {
  LoginStatefulWidget({Key key}) : super(key: key);

  @override
  _LoginStatefulWidgetState createState() => _LoginStatefulWidgetState();
}

enum FormMode { LOGIN, SIGNUP }

class _LoginStatefulWidgetState extends State<LoginStatefulWidget> {

  //Default values for Drop Downs
  final _formKey = GlobalKey<FormState>();
  String _errorMessage = null;
  FormMode _formMode = FormMode.LOGIN;


  @override
  Widget build(BuildContext context) {
    String _email = "";
    String _password = "";

    return Scaffold(
      body: Stack(
        children: <Widget>[
          //Login

          // UI inspired by: https://medium.com/flutterpub/flutter-how-to-do-user-login-with-firebase-a6af760b14d5
          new Form(
            key: _formKey,
           child: new ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                    child: Image.asset('assets/Grassroots_Green_Logo_16x9.PNG')
                ),
                //Email input
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 0.0),
                  child: new TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    decoration: new InputDecoration(
                      hintText: 'Email',
                      icon: new Icon(
                        Icons.mail,
                        color: Colors.grey,
                      )
                    ),
                    validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
                    onSaved: (value) => _email = value.trim(),
                  )
                ),
                //Password Input
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 15.0, 0.0, 20.0),
                  child: new TextFormField(
                    maxLines: 1,
                    obscureText: true,
                    autofocus: false,
                    decoration: new InputDecoration(
                      hintText: 'Password',
                      icon: new Icon(
                        Icons.lock,
                        color: Colors.grey,
                      )
                    ),
                    validator: (value) => value.isEmpty ? "Password can\'t be empty" : null,
                    onSaved: (value) => _password = value.trim(),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                  child: new MaterialButton(
                    elevation: 5.0,
                    minWidth: 200.0,
                    height: 42.0,
                    color: Colors.green,
                    child: _formMode == FormMode.LOGIN ? new Text('Login', style: new TextStyle(fontSize: 20.0, color: Colors.white))
                        : new Text('Create account', style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                    onPressed: _validateAndSubmit,
                  )
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 100.0),
                  child: new FlatButton(
                      child: _formMode == FormMode.LOGIN ? new Text('Create an account', style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300))
                          : new Text('Have an account? Sign in', style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
                    onPressed: _formMode == FormMode.LOGIN ? _changeFormToSignUp : _changeFormToLogin,
                  )
                ),
              ]
          ),
          ),
        ],
      ),
    );
  }

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  void _validateAndSubmit() async {
    // TODO: implement interaction with Firebase
  }
}
