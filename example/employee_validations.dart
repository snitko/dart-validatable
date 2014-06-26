import '../packages/attributable/attributable.dart';
import '../lib/validatable.dart';

class Employee extends Object with Attributable, Validatable {
   
  final List attribute_names = ['first_name', 'family_name', 'age', 'sex', 'email'];
   
  final Map validations = {
    
    'first_name'  : { 'isShorterThan' : 30,     'isLongerThan' : 1  },
    'family_name' : { 'isShorterThan' : 50,     'isLongerThan' : 2  },
    'age'         : { 'isNumeric'     : true,   'isMoreThan'   : 18 },
    'sex'         : { 'isOneOf' : ['f', 'm'],   'isNotEmpty' : true },
    
    'email' : { 'matches' : { 'value': new RegExp(r"@"), 'message' : 'this isn\'t an email, bro' }}
     
  };
  
  // This is required to be included into the class
  // by the Attributable mixin.
  noSuchMethod(Invocation i) {
    var result = prvt_noSuchGetterOrSetter(i);
    if(result != false)
      return result;
    else
      super.noSuchMethod(i);
  }
   
}

main() {

  var employee = new Employee();
  employee.first_name  = "Vincent";
  employee.family_name = "Vega";
  employee.validate();

  print(employee.validation_errors);

}
