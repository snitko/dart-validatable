import 'package:unittest/unittest.dart';
import 'package:attributable/attributable.dart';
import 'dart:mirrors';
import '../lib/validatable.dart';

class DummyClass extends Object with Attributable, Validatable {

  final List attribute_names = ['num1', 'num2', 'num3', 'enum1', 'enum2', 'null1', 'str1', 'str2', 'str3', 'str4', 'not_null1', 'not_empty1', 'custom_message1'];

  final Map validations = {

    'num1'  : { 'isNumeric'  : true },
    'num2'  : { 'isLessThan' : 10   },
    'num3'  : { 'isMoreThan' : 15   },

    'enum1' : { 'isOneOf'    : [1,2,3] },
    'enum2' : { 'isNotOneOf' : [1,2,3] },

    'str1'  : { 'isLongerThan'     : 5  },
    'str2'  : { 'isShorterThan'    : 10 },
    'str3'  : { 'hasExactLengthOf' : 20 },
    'str4'  : { 'matches'          : new RegExp(r"^You're the one") },

    'not_null1'  : { 'isNotNull'  : true },
    'not_empty1' : { 'isNotEmpty' : true },

    'custom_message1' : { 'isNotEmpty' : { 'value': true, 'message': "CUSTOM MESSAGE" } }

  };

  noSuchMethod(Invocation i) {
    var result = prvt_noSuchGetterOrSetter(i);
    if(result != false)
      return result;
    else
      super.noSuchMethod(i);
  }

}

main() {

  var dummy_class;
  setUp(() {
    dummy_class = new DummyClass();
  });

  /* NUMERIC VALIDATIONS */
  
  test('validates field is numeric', () {
    dummy_class.num1 = 'non numeric value';
    dummy_class.validate();
    expect(dummy_class.validation_errors['num1'].isEmpty, isFalse);
    dummy_class.num1 = '100';
    dummy_class.validate();
    expect(dummy_class.validation_errors['num1'].isEmpty, isTrue);
  });

  test('validates field is numeric and less than a certain value', () {
    dummy_class.num2 = '12';
    dummy_class.validate();
    expect(dummy_class.validation_errors['num2'].isEmpty, isFalse);
    dummy_class.num2 = '9';
    dummy_class.validate();
    expect(dummy_class.validation_errors['num2'].isEmpty, isTrue);
  });

  test('validates field is numeric and more than a certain value', () {
    dummy_class.num3 = '14';
    dummy_class.validate();
    expect(dummy_class.validation_errors['num3'].isEmpty, isFalse);
    dummy_class.num3 = '17';
    dummy_class.validate();
    expect(dummy_class.validation_errors['num3'].isEmpty, isTrue);
  });

  /* ENUM VALIDATIONS */
  test('validates field is one of the values', () {
    dummy_class.enum1 = 14;
    dummy_class.validate();
    expect(dummy_class.validation_errors['enum1'].isEmpty, isFalse);
    dummy_class.enum1 = 1;
    dummy_class.validate();
    expect(dummy_class.validation_errors['enum1'].isEmpty, isTrue);
  });

  test('validates field is not of the values', () {
    dummy_class.enum2 = 1;
    dummy_class.validate();
    expect(dummy_class.validation_errors['enum2'].isEmpty, isFalse);
    dummy_class.enum2 = 14;
    dummy_class.validate();
    expect(dummy_class.validation_errors['enum2'].isEmpty, isTrue);
  });

  /* STRING VALIDATIONS */
  test('validates field length is no more than a certain value', () {
    dummy_class.str1 = 'hello';
    dummy_class.validate();
    expect(dummy_class.validation_errors['str1'].isEmpty, isFalse);
    dummy_class.str1 = 'hello world';
    dummy_class.validate();
    expect(dummy_class.validation_errors['str1'].isEmpty, isTrue);
  });

  test('validates field length is no less than a certain value', () {
    dummy_class.str2 = 'hello world';
    dummy_class.validate();
    expect(dummy_class.validation_errors['str2'].isEmpty, isFalse);
    dummy_class.str2 = 'hello';
    dummy_class.validate();
    expect(dummy_class.validation_errors['str2'].isEmpty, isTrue);
  });

  test('validates field length is exactly the value', () {
    dummy_class.str3 = '12345678901234567890a';
    dummy_class.validate();
    expect(dummy_class.validation_errors['str3'].isEmpty, isFalse);
    dummy_class.str3 = '12345678901234567890';
    dummy_class.validate();
    expect(dummy_class.validation_errors['str3'].isEmpty, isTrue);
  });

  test('validates field matches the pattern', () {
    dummy_class.str4 = "I know, you're the one";
    dummy_class.validate();
    expect(dummy_class.validation_errors['str4'].isEmpty, isFalse);
    dummy_class.str4 = "You're the one";
    dummy_class.validate();
    expect(dummy_class.validation_errors['str4'].isEmpty, isTrue);
  });

  test('validates field is not null', () {
    dummy_class.not_null1 = null;
    dummy_class.validate();
    expect(dummy_class.validation_errors['not_null1'].isEmpty, isFalse);
    dummy_class.not_null1 = "";
    dummy_class.validate();
    expect(dummy_class.validation_errors['not_null1'].isEmpty, isTrue);
  });

  test('validates field is not empty', () {
    dummy_class.not_empty1 = "";
    dummy_class.validate();
    expect(dummy_class.validation_errors['not_empty1'].isEmpty, isFalse);
    dummy_class.not_empty1 = "not empty";
    dummy_class.validate();
    expect(dummy_class.validation_errors['not_empty1'].isEmpty, isTrue);
  });

  test('allows custom validation error messages', () {
    dummy_class.custom_message1 = "";
    dummy_class.validate();
    expect(dummy_class.validation_errors['custom_message1'].first, equals('CUSTOM MESSAGE'));
  });
  

}
