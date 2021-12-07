import 'dart:async';
import 'dart:convert';

import 'package:api1/models/profile.dart';
import 'package:api1/utils/network_util.dart';
import 'package:http/http.dart' as http;

class RestData {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "http://localhost:3000";
  static final LOGIN_URL = BASE_URL + "/auth/login";

  Future<Profile> postLogin(String email, String password) async {
    String flaglogado;
    var user = new Profile(null, email, password, null);
    http.Response res =
        await http.post(Uri.parse(LOGIN_URL), body: user.toMapLogin());
    Map data = jsonDecode(res.body);
    flaglogado = data["token"] ? "logado" : "nao";
    return new Future.value(new Profile(null, email, password, flaglogado));
  }

  Future<Profile> register(Profile user) async {
    //
    return new Future.value(new Profile(null, null, null, null));
  }
}
