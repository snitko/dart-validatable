Validatable
===========

Adds validation capabilities for attributes to a class it is mixed into.
It works together with the 'attributable' library and you should first mix `Attributable`
module into the class before mixing in this one. Then define attributes and only after that
define validations for them.

Validations work much the same way as they do in the Ruby On Rails framework. When the `validate()`
method is called, it looks at all the attributes mentioned in the `validations` Map in your class
and check if they pass the defined validations. If not, errors are added into the `validation_errors` Map.

IMPORTANT: please don't forget to check with the documentation for the 'attributable'
library before using this one.
  
Usage example
-------------

1. Mix the `Validatable` module into your class, and make sure `Attributable` is also mixed in before it:

        class Employee extends Object with Attributable, Validatable {}

2. Define attributes using the `attribute_names` instance variable (attributable library feature):

        class Employee extends Object with Attributable, Validatable {
          final List attribute_names = ['first_name', 'family_name', 'age', 'sex', 'email'];
        }

3. Define validations for these attributes:

        class Employee extends Object with Attributable, Validatable {
           
          final List attribute_names = ['first_name', 'family_name', 'age', 'sex', 'email'];
          
          final Map validations = {
             
            'first_name'  : { 'isShorterThan' : 30,     'isLongerThan' : 1  },
            'family_name' : { 'isShorterThan' : 50,     'isLongerThan' : 2  },
            'age'         : { 'isNumeric'     : true,   'isMoreThan'   : 18 },
            'sex'         : { 'isOneOf' : ['f', 'm'],   'isNotEmpty' : true },
            
            'email' : { 'matches' : { 'value': new RegExp(r"@"), 'message' : 'this isn\'t an email, bro' }}
            
          };
          
        }

4. Create a new instance of your class, set attribute values on it and run the `validate()` method:

        var employee = new Employee();
        employee.first_name  = "Vincent";
        employee.family_name = "Vega";
        employee.validate();

5. See what the validation errors contain:

        print(employee.validation_errors);


You can find and run this example in the `/example/employee_validations.dart`. Don't hesitate to play with
various validations and attribute values.


Defining a validation
---------------------
A validation in the `validations` Map consists of the following parts:

    [String attribute_name]: { [String validation_name] : [validation_argument] }
    
An *attribute_name* is simply the name of the attribute that is being validated.

A *validation_name* is the name of the validation that is being applied to it (for a list of all available validations, see section "List of available validations" of this README).

A *validation_argument* can be anything that this particular validation accepts: a String, a number or a List
(for instructions on what type of agruments are accepted for which validations, see section "List of available validations" of this README)

Any validation can accept a `Map` as a *validation_argument*. In that case, the actual validation argument should move under the `value` key of that Map.
There is another key in this Map that may be used called `message`. It allows you to specify a custom message for the cases in which the validation would fail.
From the example above:

    'email' : { 'matches' : { value: new RegExp(r"@"), 'message' : 'this isn't an email, bro' }}
    
We had to write it this way in order to specify a custom message. If we didn't need a custom message, we could've written
this validation like this:

    'email' : { 'matches' : new RegExp(r"@") }


Custom validation functions
---------------------------

You can define a custom validation function to check whatever conditions you desire:

    final Map validations = {
      'email' : { 'function' : { 'name': 'validateEmail', 'message': "doesn't look like an email" }}
    };

    prvt_validateEmail() => this.email.contains("@");

If the function returns false, it means the validation didn't pass and an error message is added.

List of available validations and their descriptions
----------------------------------------------------

* **isNumeric**
  - **Attribute type**: `String` or `num`
  - **Argument**: `Boolean`
  - **Behavior** : checks whether the value only contains numbers from 0-9. It doesn't matter if the actual type of the attribute value is `String`, rather it's important that this string contains only numbers.


* **isLessThen**
  - **Attribute type**: `num`
  - **Argument**: `num`
  - **Behavior**: checks whether the value is less than a certain number.


* **isMoreThen**
  - **Attribute type**: `num`
  - **Argument**: `num`
  - **Behavior**: checks whether the value is more than a certain number.


* **isOneOf**
  - **Attribute type**: any
  - **Argument**: `List`
  - **Behavior**: checks whether the value is present in the List passed as an argument.


* **isNotOneOf**
  - **Attribute type**: any
  - **Argument**: `List`
  - **Behavior**: checks whether the value is NOT present in the List passed as an argument.


* **isLongerThan**
  - **Attribute type**: `String`
  - **Argument**: `num`
  - **Behavior**: checks whether the value is longer than the specified number of charcaters.


* **isShorterThan**
  - **Attribute type**: `String`
  - **Argument**: `num`
  - **Behavior**: checks whether the value is shorter than the specified number of charcaters.


* **hasExactLengthOf**
  - **Attribute type**: `String`
  - **Argument**: `num`
  - **Behavior**: checks whether the value has the exact length specified in the passed argument.


* **matches**
  - **Attribute type**: `String`
  - **Argument**: `RegExp`
  - **Behavior**: checks whether the value matches the RegExp passed as an argument.


* **isNotNull**
  - **Attribute type**: any
  - **Argument**: `Boolean`
  - **Behavior**: checks whether the value is not null.


* **isNotEmpty**
  - **Attribute type**: `String`
  - **Argument**: `Boolean`
  - **Behavior**: checks whether the value is not empty (ignores if it's null).
