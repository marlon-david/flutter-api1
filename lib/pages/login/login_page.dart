import 'package:api1/data/firebase_helper.dart';
import 'package:api1/models/profile.dart';
import 'package:api1/pages/error_page.dart';
import 'package:api1/pages/login/login_presenter.dart';
import 'package:api1/utils/firebase_config.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginPageContract {
  BuildContext? _ctx;
  bool _initialized = false;
  bool _error = false;
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String? _email, _password;

  LoginPagePresenter? _presenter;

  _LoginPageState() {
    _presenter = new LoginPagePresenter(this);
  }

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp(
          options: DefaultFirebaseConfig.platformOptions);
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  void _register() {
    Navigator.of(context).pushNamed("/register");
  }

  void _submit() {
    final FormState? form = formKey.currentState;

    if (form == null) {
      print("form is null");
      return;
    }

    if (form.validate()) {
      setState(() {
        _isLoading = true;
        form.save();
        print("Entrou 01");
        _presenter?.doLogin(_email!, _password!);
      });
    } else {
      print("form not validate");
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    // if (FirebaseHelper.isLogged) {
    //   Navigator.of(this.context).pushNamed("/home");
    // }
    super.initState();
  }

  void _showSnackBar(String text) {
    // scaffoldKey.currentState.showSnackBar(new SnackBar(
    //   content: new Text(text),
    // ));
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return ErrorPage();
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Center(child: CircularProgressIndicator());
    }

    final Size screenSize = MediaQuery.of(context).size;
    _ctx = context;

    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: Colors.black87,
      primary: Colors.green,
      minimumSize: Size(88, 36),
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    );

    var loginBtn = new ElevatedButton(
        onPressed: _submit, child: new Text("Login"), style: raisedButtonStyle);

    var registerBtn = new ElevatedButton(
        onPressed: _register,
        child: new Text("Register"),
        style: raisedButtonStyle);

    var loginForm = new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Text(
          "Login",
          textScaleFactor: 2.0,
        ),
        new Form(
            key: formKey,
            child: new Column(
              children: <Widget>[
                new Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: new TextFormField(
                      onSaved: (val) => _email = val,
                      decoration: new InputDecoration(labelText: "E-mail"),
                    )),
                new Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: new TextFormField(
                      obscureText: true,
                      onSaved: (val) => _password = val,
                      decoration: new InputDecoration(labelText: "Senha"),
                    ))
              ],
            )),
        new Padding(
            padding: new EdgeInsets.all(10.0),
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : loginBtn),
        registerBtn
      ],
    );

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Login'),
        ),
        key: scaffoldKey,
        body: new Container(
            child: new Center(
          child: loginForm,
        )));
  }

  @override
  void onLoginError(String error) {
    _showSnackBar(error);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onLoginSuccess(Profile profile) async {
    print("entrou no  onLoginSuccess");

    _showSnackBar(profile.toString());
    setState(() {
      _isLoading = false;
    });

    if (profile.flaglogado == "logado") {
      print("Logado");
      Navigator.of(context).pushNamed("/home");
    } else {
      print("Nao logado");
    }
  }
}
