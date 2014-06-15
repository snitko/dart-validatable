library validatable;

import 'dart:mirrors';

abstract class Validatable {

  bool valid = true;

  Map validations       = {};
  Map validation_errors = {};

  validate() {

    valid = true;

    // remove previous validation errors
    validation_errors = {};    

    validations.forEach((field_name, field_validations) {

      if(validation_errors[field_name] == null)
        validation_errors[field_name] = [];

      field_validations.forEach((v_name, v_arg) {
        try {
          if(!(v_arg is Map))
            v_arg = { 'value': v_arg, 'message': null };
          reflect(this).invoke(new Symbol('prvt_validate_${v_name}'), [field_name, v_arg]);
        } on NoSuchMethodError catch(e) {
          var error_message = e.toString();
          if(error_message.contains("has no instance method 'prvt_validate_"))
            throw new Exception('Validation `$v_name` was not found in class `${MirrorSystem.getName(reflect(this).type.simpleName)}`');
          else
            throw e;
        }
      });

      validation_errors.forEach((field_name, errors) {
        if(!errors.isEmpty) {
          valid = false;
          return;
        }
      });

    });
  }


  prvt_validate_isNumeric(field_name, v) {
    
    var field_value = _getFieldValue(field_name);
    if(field_value == null || field_value is num) return;

    var result = field_value.contains(new RegExp(r'^\d+$'));
    if(!result && v['value'])
      validation_errors[field_name].add(_getValidationErrorMessage('is not a number', v));
    else if(result && !v['value'])
      validation_errors[field_name].add(_getValidationErrorMessage('is a number, but it shouldn\'t be', v));
  }


  prvt_validate_isLessThan(field_name, v) {
    var field_value = _getFieldValue(field_name);
    if(field_value == null || _getNumericValue(field_value) >= v['value'])
      validation_errors[field_name].add(_getValidationErrorMessage("should be less than ${v['value']}", v));
  }
  prvt_validate_isMoreThan(field_name, v) {
    var field_value = _getFieldValue(field_name);
    if(field_value == null || _getNumericValue(field_value) <= v['value'])
      validation_errors[field_name].add(_getValidationErrorMessage("should be more than ${v['value']}", v));
  }


  prvt_validate_isOneOf(field_name, v) {
    if(!_checkIsOneOf(field_name, v['value']))
      validation_errors[field_name].add(_getValidationErrorMessage("should be one of the following: ${v['value'].join(', ')}", v));
  }
  prvt_validate_isNotOneOf(field_name, v) {
    if(_checkIsOneOf(field_name, v['value']))
      validation_errors[field_name].add(_getValidationErrorMessage("should NOT be one of the following: ${v['value'].join(', ')}", v));
  }


  prvt_validate_isLongerThan(field_name, v) {
    var field_value = _getFieldValue(field_name);
    if(field_value == null || field_value.length <= v['value'])
      validation_errors[field_name].add(_getValidationErrorMessage("should be longer than ${v['value']}", v));
  }
  prvt_validate_isShorterThan(field_name, v) {
    var field_value = _getFieldValue(field_name);
    if(field_value == null || field_value.length >= v['value'])
      validation_errors[field_name].add(_getValidationErrorMessage("should be shorter than ${v['value']}", v));
  }


  prvt_validate_hasExactLengthOf(field_name, v) {
    var field_value = _getFieldValue(field_name);
    if(field_value == null || field_value.length != v['value'])
      validation_errors[field_name].add(_getValidationErrorMessage("should have the length of ${v['value']}", v));
  }

  prvt_validate_matches(field_name, v) {
    var field_value = _getFieldValue(field_name);
    if(field_value == null || !field_value.contains(v['value']))
      validation_errors[field_name].add(_getValidationErrorMessage('has wrong format', v));
  }

  prvt_validate_isNotNull(field_name, v) {
    var field_value = _getFieldValue(field_name);
    if(field_value == null)
      validation_errors[field_name].add(_getValidationErrorMessage('should not be null', v));
  }

  prvt_validate_isNotEmpty(field_name, v) {
    var field_value = _getFieldValue(field_name);
    if(field_value == null)
      return;
    else if(field_value.isEmpty)
      validation_errors[field_name].add(_getValidationErrorMessage('should not be empty', v));
  }

  _checkIsOneOf(field_name, v) {
    return v.contains(_getFieldValue(field_name));
  }

  _getFieldValue(field_name) {
    return reflect(this).getField(new Symbol(field_name)).reflectee;
  }

  _getValidationErrorMessage(default_message, v) {
    return v['message'] == null ? default_message : v['message'];
  }

  _getNumericValue(v) {
    if(v is String)
      return double.parse(v);
    else
      return v;
  }

}
