// Package imports:
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

var creditCardNumberMaskFormatter = new MaskTextInputFormatter(
    mask: '#### #### #### ####', filter: {"#": RegExp(r'[0-9]')});

var creditCardValidityMaskFormatter = new MaskTextInputFormatter(
    mask: '## / ##', filter: {"#": RegExp(r'[0-9]')});

var creditCardCVVMaskFormatter =
    new MaskTextInputFormatter(mask: '###', filter: {"#": RegExp(r'[0-9]')});

var phoneNumberMaskFormatter = new MaskTextInputFormatter(
    mask: '### ## ## ##', filter: {"#": RegExp(r'[0-9]')});
