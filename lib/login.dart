/*  login.dart
*
* A class used to implement the login of users in the application
*
*/
import 'package:flutter/material.dart';
import 'package:grassroots_green/auth.dart';
import 'package:email_validator/email_validator.dart';

class Login extends StatelessWidget {
  /// Login page of the app.

  /// Constructor for the login page.
  Login({this.auth});

  /// Route name for navigation to the login page.
  static const String routeName = "/login";
  /// Authenticator with user data.
  final BaseAuth auth;

  /// Builds the Scaffold for the login page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor, //change your color here
        ),
          title: Text(
            'Login',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          backgroundColor: Theme.of(context).accentColor,
      ),
      body: LoginStatefulWidget(auth: auth),
    );
  }
}

class LoginStatefulWidget extends StatefulWidget {
  /// Login page's Stateful Widget.

  /// Constructor for the LoginStatefulWidget
  LoginStatefulWidget({Key key, this.auth}) : super(key: key);

  /// Authenticator with user data.
  final BaseAuth auth;

  /// Creates the state of the login page.
  @override
  _LoginStatefulWidgetState createState() => _LoginStatefulWidgetState();

  /// Post-sign in action.
  void onSignedIn(BuildContext context) {
    Navigator.pop(context);
  }
}

/// Enum for login or create account mode
enum FormMode { LOGIN, SIGNUP }

class _LoginStatefulWidgetState extends State<LoginStatefulWidget> {
  /// State for Login page.

  /// Key for login form.
  final _formKey = GlobalKey<FormState>();
  /// Error message on login.
  String _errorMessage = "";
  /// Mode of login form, either LOGIN or SIGNUP.
  FormMode _formMode = FormMode.LOGIN;
  /// If app is running on iOS.
  bool _isIos;
  /// Email for user entry.
  String _email = "";
  /// Password for user entry.
  String _password = "";


  /// Builds the Scaffold of the login page.
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

  /// Toggles form to be the sign up form.
  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  /// Toggles form to be the login form.
  void _changeFormToLogin() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  /// Validates and submits the login form
  ///
  /// If currently in LOGIN state, will attempt to log the user in.
  /// If currently in SIGNUP state, will attempt to create a new user account.
  _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        if (_formMode == FormMode.LOGIN) {
          userId = await widget.auth.signIn(_email, _password);
          if (userId == null) {
            return;
          }
          print('Signed in: $userId');
        } else {
          userId = await widget.auth.signUp(_email, _password);
          print('Signed up user: $userId');
        }
        if (userId.length > 0 && userId != null) {
          widget.onSignedIn(context);
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          if (_isIos) {
            _errorMessage = e.details;
          } else
            _errorMessage = e.message;
        });
      }
    }
  }

  /// Checks if form is valid before perform login or signup.
  ///
  /// Confirms that email is a valid email address.
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  /// Displays an error messages from user login.
  ///
  /// Displays errors regarding account existence or invalid credentials.
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
