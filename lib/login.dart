/*  login.dart
*
* A class used to implement the login of users in the application
*
*/
import 'package:flutter/material.dart';
import 'package:grassroots_green/auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:grassroots_green/main.dart';

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
  StatefulWidget onSignedIn(BuildContext context) {
    Navigator.pushReplacementNamed(context, MyHomePage.routeName);
  }
}

/// Enum for login or create account mode
enum FormMode { LOGIN, SIGNUP, RESET }

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

    return new Scaffold(
      body: Stack(
        children: <Widget>[
          //Login

          // UI inspired by: https://medium.com/flutterpub/flutter-how-to-do-user-login-with-firebase-a6af760b14d5


              _showBody(),

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

  /// Toggles form to be the login form.
  void _changeFormToReset() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.RESET;
    });
  }




  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
          new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                _changeFormToLogin();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showPasswordEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Forgot your password"),
          content: new Text("An email has been sent to reset your password"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                _changeFormToLogin();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _showBody() {
    return  Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0, 0.0, 0.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showLogo(),
              _showEmailInput(),
              _showPasswordInput(),
              _showPrimaryButton(),
              _showSecondaryButton(),
              _showForgotPasswordButton(),
            ],
          ),
        ));
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/Grassroots_Green_Logo_16x9.PNG'),
        ),
      ),
    );
  }



  Widget _showEmailInput() {
    return Padding(
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
              ),
              errorStyle: TextStyle(fontSize: 16.0),
          ),
          validator: (value) => EmailValidator.validate(value) ? null : "Invalid email",
          onSaved: (value) => _email = value.trim(),
        )
    );
  }

  Widget _showPasswordInput() {
    if (_formMode != FormMode.RESET) {
      return Padding(
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
                ),
                errorStyle: TextStyle(fontSize: 16.0),
            ),
            validator: (value) =>
            value.isEmpty || value.length < 6
                ? "Password must be at least 6 characters"
                : null,
            onSaved: (value) => _password = value.trim(),
          ));
    }  else {
      return new Text('An email will be sent allowing you to reset your password',
          style:
          new TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300));
    }
  }



  Widget _showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.green,
            child: _textPrimaryButton(),
            onPressed:  _validateAndSubmit,
          ),
        ));
  }

  Widget _showSecondaryButton() {
    return new FlatButton(
      child: _textSecondaryButton(),
      onPressed: _formMode == FormMode.LOGIN
          ? _changeFormToSignUp
          : _changeFormToLogin,
    );
  }

  Widget _showForgotPasswordButton() {
    return new FlatButton(
      child: _formMode == FormMode.LOGIN
          ? new Text('Forgot password?',
          style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300))
          : new Text('',
          style:
          new TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300)),
      onPressed:  _changeFormToReset,
    );
  }

  Widget _textPrimaryButton() {
    switch (_formMode) {
      case FormMode.LOGIN:
        return new Text('Login',
            style: new TextStyle(fontSize: 20.0, color: Colors.white));
        break;
      case FormMode.SIGNUP:
        return new Text('Create account',
            style: new TextStyle(fontSize: 20.0, color: Colors.white));
        break;
      case FormMode.RESET:
        return new Text('Reset password',
            style: new TextStyle(fontSize: 20.0, color: Colors.white));
        break;
    }
    return new Spacer();
  }

  Widget _textSecondaryButton() {
    switch (_formMode) {
      case FormMode.LOGIN:
        return new Text('Create an account',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300));
        break;
      case FormMode.SIGNUP:
        return new Text('Have an account? Sign in',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300));
        break;
      case FormMode.RESET:
        return new Text('Enter your email address or ... Cancel',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300));
        break;
    }
    return new Spacer();
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
        }  else if (_formMode ==FormMode.SIGNUP){
          userId = await widget.auth.signUp(_email, _password);
          print('Signed up user: $userId');
        } else {
          widget.auth.sendPasswordReset(_email);
          _showPasswordEmailSentDialog();
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

}
