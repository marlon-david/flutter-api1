import 'package:api1/data/firebase_helper.dart';
import 'package:api1/data/rest_data.dart';
import 'package:api1/models/profile.dart';

abstract class LoginPageContract {
  void onLoginSuccess(Profile profile);
  void onLoginError(String error);
}

class LoginPagePresenter {
  LoginPageContract _view;
  RestData api = new RestData();
  FirebaseHelper helper = new FirebaseHelper();
  LoginPagePresenter(this._view);

  doLogin(String email, String password) {
    helper
        .postLogin(email, password)
        .then((profile) => _view.onLoginSuccess(profile))
        .catchError((onError) => _view.onLoginError(onError));
  }
}
