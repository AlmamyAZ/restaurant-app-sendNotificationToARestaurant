// Flutter imports:

// Package imports:
import 'package:form_field_validator/form_field_validator.dart';

// Project imports:
import 'package:restaurant_app/ui/shared/validators_register.dart';

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: '*Champs obligatoire'),
  MinLengthValidator(8, errorText: '8 charactères au minimum'),
]);

final emailValidator = MultiValidator([
  RequiredValidator(errorText: '*Champs obligatoire'),
  EmailValidator(errorText: 'Format d\'email invalide'),
]);
final rechargeValidator = MultiValidator([
  RequiredValidator(errorText: '*Champs obligatoire'),
  NumericValidator(errorText: 'Format d\'email invalide'),
]);

final codeValidator = MultiValidator([
  RequiredValidator(errorText: '*Champs obligatoire'),
]);

final phoneValidator = MultiValidator([
  RequiredValidator(errorText: '*Champs obligatoire'),
  // LengthRangeValidator(
  //     errorText: 'Format de numero invalide', min: 12, max: 12),
  NumericValidator(errorText: 'Format de numero invalide **'),
]);

class AlphanumericValidator extends TextFieldValidator {
  // pass the error text to the super constructor
  RegExp _alphanumeric = new RegExp(r'^[a-zA-Z0-9]+$');

  AlphanumericValidator(
      {String errorText =
          'Le champs de dois contenir que des characters alphanumeriques'})
      : super(errorText);

  // return false if you want the validator to return error
  // message when the value is empty.
  @override
  bool get ignoreEmptyValues => true;

  @override
  bool isValid(String? value) {
    // return true if the value is valid according the your condition
    // return hasMatch(RegexPattern.alphabetOnly, value);
    return _alphanumeric.hasMatch(value!);
  }
}

class NumericValidator extends TextFieldValidator {
  NumericValidator({required String errorText}) : super(errorText);

  @override
  bool get ignoreEmptyValues => true;

  @override
  bool isValid(String? value) {
    return isNumeric(value!.split(' ').join());
  }

  @override
  String? call(String? value) {
    print('errorText ${value!.length}');
    return isValid(value) ? null : 'errorText ${value.length}';
  }
}
