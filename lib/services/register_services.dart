import '../models/register.dart';
import 'package:projeto/repositories/repository.dart';

class RegisterService {

  Repository _repository;

  RegisterService() {
    _repository = Repository();//instanciou
  }

  saveRegister(Register register) async{
    return await _repository.save('registers', register.registerMap());
  }

  getRegisters() async {
    return await _repository.getAll('registers');
  }

   getRegisterById(id) async{
     return await _repository.getById('registers', id);
  }
}
