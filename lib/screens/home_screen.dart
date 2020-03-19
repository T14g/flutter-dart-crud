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
  var _selecionado ;

  DateTime _date = DateTime.now();


  //Edit variables
  var _updateAlfa = TextEditingController();
  var _updateInteiro = TextEditingController();
  var _updateDecimal = TextEditingController();
  var _updateDia = TextEditingController();
  var _updateSelecionado;

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

  List<Register> _registerList;

  @override
  void initState() {
    super.initState();
    getAllRegisters();
  }

  getAllRegisters() async {
    _registerList =  List<Register>();
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
              value: _updateSelecionado,
              items: [
                DropdownMenuItem(child: Text('Casa'), value: 'Casa'),
                DropdownMenuItem(child: Text('Carro'), value: 'Carro'),
                DropdownMenuItem(child: Text('BMW'), value: 'BMW'),
              ],
              hint: Text('Selecione uma opção!'),
              onChanged: (value){
                setState(() {
                  print(value);
                  _updateSelecionado = value;
                });
              },
            )

          ]
        )
      ), 
      );
    });
  }


// Edit Dialog 
_editDialog(BuildContext context, idReg){
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
            _register.id            = idReg;
            _register.alfanumerico = _updateAlfa.text;
            _register.inteiro       = _updateInteiro.text ;
            _register.decimal       = _updateDecimal.text ;
            _register.dia           = _updateDia.text;
            _register.selecionado   = _updateSelecionado;
            var result = await _registerService.updateRegister(_register);
            getAllRegisters();
            print(result);
            Navigator.pop(context);
          },
          child: Text('Update')
        )
      ],  
      title: Text('Editar registro'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _updateAlfa,
              decoration: InputDecoration(
                labelText: 'Campo Alfanumérico'
              ),
            ),
            TextField(
              controller: _updateInteiro,
              decoration: InputDecoration(
                labelText: 'Campo Número inteiro'
              ),
              keyboardType: TextInputType.number
            ),
             TextField(
              controller: _updateDecimal,
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
              controller: _updateDia,
              decoration: InputDecoration(
                labelText: 'dd-MM-yyyy',
                prefixIcon: InkWell(onTap: (){
                  _selectDate(context);
                },child: Icon(Icons.calendar_today)) 
              ),
            ),
            DropdownButtonFormField(
              value: _updateSelecionado,
              items: [
                DropdownMenuItem(child: Text('Casa'), value: 'Casa'),
                DropdownMenuItem(child: Text('Carro'), value: 'Carro'),
                DropdownMenuItem(child: Text('BMW'), value: 'BMW'),
              ],
              hint: Text('Selecione uma opção!'),
              onChanged: (value){
                setState(() {
                  print(value);
                  _updateSelecionado = value;
                });
              },
            )

          ]
        )
      ), 
      );
    });
  }

  _editRegister(BuildContext context, registerId) async{
    var registro = await _registerService.getRegisterById(registerId);
    print(registro[0]['alfanumerico']);
    setState((){
        _updateAlfa.text = registro[0]['alfanumerico'];
        _updateInteiro.text = registro[0]['inteiro'];
        _updateDecimal.text = registro[0]['decimal'];
        _updateDia.text = registro[0]['dia'];
        _updateSelecionado = registro[0]['selecionado'];
    });

    _editDialog(context,registerId);
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
                onPressed: () { 
                  var id = _registerList[index].id;
                  _editRegister(context, id );
                },
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

