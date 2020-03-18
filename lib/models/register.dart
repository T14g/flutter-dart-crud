class Register {
  int id;
  String inteiro;
  String decimal;
  String alfanumerico;
  String dia;
  String selecionado;

  registerMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['alfanumerico'] = alfanumerico;
    map['inteiro'] = inteiro;
    map['decimal'] = decimal;
    map['selecionado'] = selecionado;
    map['dia'] = dia;

    return map;
  }
}