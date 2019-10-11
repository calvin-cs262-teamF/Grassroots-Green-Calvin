import 'package:flutter/material.dart';
import 'package:grassroots_green/auth.dart';
import 'package:email_validator/email_validator.dart';

class Login extends StatelessWidget {
  Login({this.auth});

  static const String routeName = "/login";
  final BaseAuth auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: LoginStatefulWidget(),
    );
  }
}

class LoginStatefulWidget extends StatefulWidget {
  LoginStatefulWidget({Key key, this.auth}) : super(key: key);

  final BaseAuth auth;

  @override
  _LoginStatefulWidgetState createState() => _LoginStatefulWidgetState();

  void onSignedIn() {
    // TODO: define. Specifically, make it go back to home
  }
}

enum FormMode { LOGIN, SIGNUP }

class _LoginStatefulWidgetState extends State<LoginStatefulWidget> {

  //Default values for Drop Downs
  final _formKey = GlobalKey<FormState>();
  String _errorMessage = "";
  FormMode _formMode = FormMode.LOGIN;
  bool _isLoading = true;
  bool _isIos;
  String _email = "";
  String _password = "";


  @override
  Widget build(BuildContext context) {

    _isIos = Theme.of(context).platform == TargetPlatform.iOS;

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
                    validator: (value) => EmailValidator.validate(value) ? null : "Invalid email",
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
                    validator: (value) => value.isEmpty || value.length < 6 ? "Password must be at least 6 characters" : null,
                    onSaved: (value) => _password = value.trim(),
                  )
                ),
                _showErrorMessage(),
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

  _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        if (_formMode == FormMode.LOGIN) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          userId = await widget.auth.signUp(_email, _password);
          print('Signed up user: $userId');
        }
        if (userId.length > 0 && userId != null) {
          widget.onSignedIn();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessage = e.details;
          } else
            _errorMessage = e.message;
        });
      }
    }
  }

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }
}
