class Profile {
  String? _id;
  String? _email;
  String? _password;
  String? _flaglogado;

  Profile(this._id, this._email, this._password, this._flaglogado);

  Profile.map(dynamic obj) {
    this._id = obj['id'];
    this._email = obj['email'];
    this._password = obj['password'];
    this._flaglogado = obj['password'];
  }

  String? get name => _id;
  String? get email => _email;
  String? get password => _password;
  String? get flaglogado => _flaglogado;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["email"] = _email;
    map["password"] = _password;
    map["flaglogado"] = _flaglogado;
    return map;
  }

  Map<String, dynamic> toMapLogin() {
    var map = new Map<String, dynamic>();
    map["email"] = _email;
    map["password"] = _password;
    return map;
  }
}
