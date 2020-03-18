import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto/models/register.dart';
import 'package:projeto/services/register_services.dart';
import 'package:projeto/services/currency_format.dart';
import 'package:intl/intl.dart';


// Texto alfanumérico
// Campo número inteiro
// Campo Moeda float/double + R$
// DATA
// SELEÇÃO VALORES VALIDOS

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //R$ currency format
  var _formatBR = CurrencyPtBrInputFormatter();
  

  //Controllers
  var _alfanumerico = TextEditingController();
  var _inteiro = TextEditingController();
  var _decimal = TextEditingController();
  var _dia = TextEditingController();
  var _selectOptions = List<DropdownMenuItem>();
  var _selecionado ;

  DateTime _date = DateTime.now();

  //Method for getting the calendar
  _selectDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2000), lastDate: DateTime(2099));
    if(_pickedDate != null){
      setState(() {
        _date = _pickedDate;
        _dia.text = DateFormat('dd-MM-yyyy').format(_pickedDate); 
      });
    }
  }

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
         print(register);
        model.id = register['id'];
        model.alfanumerico = register['alfanumerico'];
        model.inteiro = register['inteiro'];
        model.decimal = register['decimal'];
        model.dia = register['dia'];
        model.selecionado = register['selecionado'];
        _registerList.add(model);
      });
    });
  }

  getById(BuildContext context, id) async {
    var registers =_registerService.getRegisterById(id);
  }

  


  //Add Dialog, _ = private
  _showFormDialog(BuildContext context){
    return showDialog(context: context, barrierDismissible: true, builder: (param){
      return AlertDialog(
      actions: <Widget>[
        FlatButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text('Cancelar')
        ),
        FlatButton(
          onPressed: () async{
            _register.alfanumerico = _alfanumerico.text;
            _register.inteiro       = _inteiro.text ;
            _register.decimal       = _decimal.text ;
            _register.dia           = _dia.text;
            _register.selecionado   = _selecionado;
            var result = await _registerService.saveRegister(_register);
            getAllRegisters();
            print(result);
            Navigator.pop(context);
          },
          child: Text('Salvar')
        )
      ],  
      title: Text('Adicionar registro'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _alfanumerico,
              decoration: InputDecoration(
                labelText: 'Campo Alfanumérico'
              ),
            ),
            TextField(
              controller: _inteiro,
              decoration: InputDecoration(
                labelText: 'Campo Número inteiro'
              ),
              keyboardType: TextInputType.number
            ),
             TextField(
              controller: _decimal,
              decoration: InputDecoration(
                labelText: 'Campo Número Float'
              ),
              keyboardType: TextInputType.numberWithOptions(),
              inputFormatters:[
                WhitelistingTextInputFormatter.digitsOnly,
                _formatBR
                ],
            ),
            TextField(
              controller: _dia,
              decoration: InputDecoration(
                labelText: 'dd-MM-yyyy',
                prefixIcon: InkWell(onTap: (){
                  _selectDate(context);
                },child: Icon(Icons.calendar_today)) 
              ),
            ),
            DropdownButtonFormField(
              value: _selecionado,
              items: [
                DropdownMenuItem(child: Text('Casa'), value: 'Casa'),
                DropdownMenuItem(child: Text('Carro'), value: 'Carro'),
                DropdownMenuItem(child: Text('BMW'), value: 'BMW'),
              ],
              hint: Text('Selecione uma opção!'),
              onChanged: (value){
                setState(() {
                  print(value);
                  _selecionado = value;
                });
              },
            )

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
            child: Column(
        children: [
          ListTile(
            title: Text(_registerList[index].alfanumerico ?? 'Not filled')
          ),
           ListTile(
            title: Text(_registerList[index].inteiro ?? 'Not filled')
          ),
           ListTile(
            title: Text(_registerList[index].decimal ?? 'Not filled')
          ),
           ListTile(
            title: Text(_registerList[index].dia ?? 'Not filled')
          ),
           ListTile(
            title: Text(_registerList[index].selecionado ?? 'Not filled')
          ),
          Divider(),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: const Text('DELETAR'),
                onPressed: () async{
                  var id = _registerList[index].id;
                  // print(_registerList[index].id);
                  var result = await _registerService.deleteRegister(id);
                  print(result);
                 },
              ),
              FlatButton(
                child: const Text('EDITAR'),
                onPressed: () { /* ... */ },
              ),
            ],
          ),
        
        ],
      ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        _showFormDialog(context);
      }, child: Icon(Icons.add),),
    );
  }
}

