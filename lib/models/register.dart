class Register {
  int id;
  String alfanumerico;
  String numero;

  registerMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['alfanumerico'] = alfanumerico;
    map['inteiro'] = numero;

    return map;
  }
}