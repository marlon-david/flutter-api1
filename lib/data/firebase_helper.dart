import 'dart:convert';

import 'package:api1/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class FirebaseHelper {
  static final BASE_URL =
      "https://marlondgoliveira-default-rtdb.firebaseio.com";
  static final LOGIN_URL = BASE_URL + "/auth/login";
  static final USERS_URL = BASE_URL + "/users.json";

  static void listenAuthActions(BuildContext context, bool isLogin) {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        if (!isLogin) {
          Navigator.of(context).pushNamed("/login");
        }
      } else {
        if (isLogin) {
          Navigator.of(context).pushNamed("/home");
        }
      }
    });
  }

  static bool get isLogged {
    return _auth.currentUser != null;
  }

  Future<Profile> postLogin(String email, String password) async {
    String flaglogado;

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print(userCredential);
      flaglogado = "logado";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        print('Usuário ou senha inválidos');
      }
      flaglogado = "nao";
    }

    return new Future.value(
        new Profile(_auth.currentUser!.uid, email, password, flaglogado));
  }

  Future<Profile> registerAsProfile(Profile profile) async {
    http.Response res = await http.post(Uri.parse(USERS_URL),
        body:
            jsonEncode({'email': profile.email, 'password': profile.password}));
    final id = jsonDecode(res.body)['name'];
    print(jsonDecode(res.body));
    return new Future.value(
        new Profile(id, profile.email, profile.password, null));
  }

  Future<Profile> register(Profile profile) async {
    final User? user = (await _auth.createUserWithEmailAndPassword(
            email: profile.email!, password: profile.password!))
        .user;
    if (user != null) {
      // print(user);
      /* retorno: User(displayName: null, email: marlon_dg_oliveira@outlook.com, emailVerified: false, isAnonymous: false, metadata:
UserMetadata(creationTime: 2021-12-05 19:08:03.000, lastSignInTime: 2021-12-05 19:08:03.000), phoneNumber: null, photoURL:
null, providerData, [UserInfo(displayName: null, email: marlon_dg_oliveira@outlook.com, phoneNumber: null, photoURL: null,
providerId: password, uid: marlon_dg_oliveira@outlook.com)], refreshToken:
AFxQ4_qCV-hE8aELjS8z2x-Sm6qWu3qVcuB1whSdLcWZgbhUJXUffwtU1zHEqsiVJKMa4x_DWUowAhkvCmh8fMIN_vXDCEXgXN_tc59JJ6nyBwc8TdKuQaF9LF7eVuz
HTTRthqUtk1a8tXBtRrDwHXn5jDbgQiEq0EZA85SMfKxHvsbaVAoMmydBjgcKt4OMAzDmyqlPgcbo0ZgrBeyU_WLHE66Odtx1xVTOUK8tnsRxOqYqivGNqy4,
tenantId: null, uid: cQDpoO4amyTZXdgTnPRuakHoxkv2) */
      return new Profile(user.uid, user.email, null, null);
    } else {
      return new Profile(null, null, null, null);
    }
  }
}
