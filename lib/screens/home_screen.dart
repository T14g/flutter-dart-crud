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
  var _fieldAlphanumeric = TextEditingController();
  var _fieldNumber = TextEditingController();
  var _fieldNumberFloat = TextEditingController();
  var _fieldDate = TextEditingController();
  var _selectOptions = List<DropdownMenuItem>();
  var _fieldSelect ;

  DateTime _date = DateTime.now();

  //Method for getting the calendar
  _selectDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2000), lastDate: DateTime(2099));
    if(_pickedDate != null){
      setState(() {
        _date = _pickedDate;
        _fieldDate.text = DateFormat('dd-MM-yyyy').format(_pickedDate); 
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
        model.alfanumerico = register['alfanumerico'];
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
            _register.alfanumerico = _fieldAlphanumeric.text;
            _register.numero       = _fieldNumber.text;
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
              controller: _fieldAlphanumeric,
              decoration: InputDecoration(
                labelText: 'Campo Alfanumérico'
              ),
            ),
            TextField(
              controller: _fieldNumber,
              decoration: InputDecoration(
                labelText: 'Campo Número inteiro'
              ),
              keyboardType: TextInputType.number
            ),
             TextField(
              controller: _fieldNumberFloat,
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
              controller: _fieldDate,
              decoration: InputDecoration(
                labelText: 'dd-MM-yyyy',
                prefixIcon: InkWell(onTap: (){
                  _selectDate(context);
                },child: Icon(Icons.calendar_today)) 
              ),
            ),
            DropdownButtonFormField(
              value: _fieldSelect,
              items: [
                DropdownMenuItem(child: Text('Casa'), value: 'Casa'),
                DropdownMenuItem(child: Text('Carro'), value: 'Carro'),
                DropdownMenuItem(child: Text('BMW'), value: 'BMW'),
              ],
              hint: Text('Selecione uma opção!'),
              onChanged: (value){
                setState(() {
                  print(value);
                  _fieldSelect = value;
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
            child: ListTile( 
              leading: IconButton(icon: Icon(Icons.info), onPressed: (){}),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_registerList[index].alfanumerico ?? 'Not filled'),
                  IconButton(icon: Icon(Icons.edit), onPressed: (){}),
                ],
                ),
                trailing: IconButton(icon: Icon(Icons.delete), onPressed: (){},),
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

