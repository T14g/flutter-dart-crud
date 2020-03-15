import 'package:flutter/material.dart';
import 'package:projeto/models/register.dart';
import 'package:projeto/services/register_services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //Controllers
  var _fieldAlphanumeric = TextEditingController();
  var _fieldNumber = TextEditingController();

  //Models
  var _register = Register();
  var _registerService = RegisterService();

  List<Register> _registerList = List<Register>();

  @override
  void initState() {
    super.initState();
    getAllRegisters();
  }

  getAllRegisters() async {
    var registers = await _registerService.getRegisters();
    registers.forEach((register){
      setState(() {
         var model = Register();
        model.alfanumerico = register['alfanumerico'];
        _registerList.add(model);
      });
    });
  }

  


  //Add Dialog, _ = private
  _showFormDialog(BuildContext context){
    return showDialog(context: context, barrierDismissible: true, builder: (param){
      return AlertDialog(
      actions: <Widget>[
        FlatButton(
          onPressed: (){
          },
          child: Text('Cancelar')
        ),
        FlatButton(
          onPressed: () async{
            _register.alfanumerico = _fieldAlphanumeric.text;
            _register.numero       = _fieldNumber.text;
            var result = await _registerService.saveRegister(_register);
            getAllRegisters();
            print(result);
          },
          child: Text('Salvar')
        )
      ],  
      title: Text('Adicionar registro'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _fieldAlphanumeric,
              decoration: InputDecoration(
                labelText: 'Campo Alfanumérico'
              ),
            ),
            TextField(
              controller: _fieldNumber,
              decoration: InputDecoration(
                labelText: 'Campo Número'
              ),
            ),

          ]
        )
      ), 
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crud By T14g"),
      ),
      body: ListView.builder(
        itemCount: _registerList.length,
        itemBuilder: (context,index){
          return Card(
            child: ListTile( 
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_registerList[index].alfanumerico ?? 'Not filled')
                ],
                )
            )
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        _showFormDialog(context);
      }, child: Icon(Icons.add),),
    );
  }
}