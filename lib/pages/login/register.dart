import 'package:api1/data/firebase_helper.dart';
import 'package:flutter/material.dart';
import 'package:api1/data/rest_data.dart';
import 'package:api1/models/profile.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  BuildContext? _ctx;
  bool _isLoading = false;
  final formkey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String? _name, _email, _password;

  @override
  Widget build(BuildContext context) {
    _ctx = context;

    var registerBtn = new RaisedButton(
      onPressed: _submit,
      child: new Text("Register"),
      color: Colors.green,
    );

    var registerForm = new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Text(
          "Register",
          textScaleFactor: 2.0,
        ),
        new Form(
            key: formkey,
            child: new Column(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new TextFormField(
                    onSaved: (val) => _name = val,
                    decoration: new InputDecoration(labelText: "Name"),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new TextFormField(
                    onSaved: (val) => _email = val,
                    decoration: new InputDecoration(labelText: "Email"),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new TextFormField(
                    onSaved: (val) => _password = val,
                    decoration: new InputDecoration(labelText: "Password"),
                  ),
                ),
              ],
            )),
        _isLoading ? Center(child: CircularProgressIndicator()) : registerBtn
      ],
    );

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Register'),
        ),
        key: scaffoldKey,
        body: new Container(
            child: new Center(
          child: registerForm,
        )));
  }

  void _submit() {
    final form = formkey.currentState;

    if (form == null) {
      return;
    }

    if (form.validate()) {
      setState(() {
        _isLoading = true;
        form.save();
        var profile = new Profile(null, _email, _password, null);
        var api = new FirebaseHelper();
        api.register(profile);
        _isLoading = false;
        //Navigator.of(context).pushNamed("/login");
        Navigator.of(context).pop();
      });
    }
  }
}
