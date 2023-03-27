// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:restaurant_app/ui/shared/shared_styles.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'note_text.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType? textInputType;
  final bool? password;
  final bool? isReadOnly;
  final String? Function(String?)? validator;
  final String placeholder;
  final String? validationMessage;
  final String? label;
  final String? prefix;
  final void Function()? suffixFunction;
  final String? suffix;
  final int? maxLength;
  final bool? enabled;
  final String? initialValue;
  final Function? enterPressed;
  final bool? smallVersion;
  final int? maxLines;
  final bool? autofocus;
  final FocusNode? fieldFocusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction? textInputAction;
  final String? additionalNote;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? formatters;

  InputField(
      {required this.controller,
      required this.placeholder,
       this.enterPressed,
       this.fieldFocusNode,
       this.nextFocusNode,
       this.additionalNote,
       this.onChanged,
        this.validator,
       this.formatters,
       this.initialValue,
       this.validationMessage,
       this.label,
       this.suffixFunction,
       this.prefix,
       this.suffix,
       this.maxLength,
       this.enabled,
      this.textInputAction = TextInputAction.next,
      this.textInputType = TextInputType.text,
      this.maxLines = 1,
      this.password = false,
      this.autofocus = false,
      this.isReadOnly = false,
      this.smallVersion = false})
      : assert(
          (suffix != null && suffixFunction != null) ||
              (suffix == null && suffixFunction == null),
        );

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool? isPassword;
  double? fieldHeight;

  @override
  void initState() {
    super.initState();
    isPassword = widget.password;
    fieldHeight = widget.maxLines != 1 ? 100 : 55;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: widget.smallVersion! ? 40 : fieldHeight,
          alignment: Alignment.centerLeft,
          padding: fieldPadding,
          decoration:
              widget.isReadOnly! ? disabledFieldDecortaion : fieldDecortaion,
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  initialValue: widget.initialValue,
                  maxLength: widget.maxLength,
                  maxLines: widget.maxLines,
                  style: !widget.isReadOnly!
                      ? TextStyle(
                          fontSize: widget.smallVersion! ? 14 : 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)
                      : TextStyle(
                          fontSize: widget.smallVersion! ? 14 : 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                  keyboardType: widget.textInputType,
                  focusNode: widget.fieldFocusNode,
                  autofocus: widget.autofocus!,
                  textInputAction: widget.textInputAction,
                  onChanged: widget.onChanged,
                  validator: widget.validator,
                  enabled: widget.enabled,
                  inputFormatters:
                      widget.formatters != null ? widget.formatters : null,
                  onEditingComplete: () {
                    if (widget.enterPressed != null) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      widget.enterPressed!();
                    }
                  },
                  onFieldSubmitted: (value) {
                    if (widget.nextFocusNode != null) {
                      widget.nextFocusNode?.requestFocus();
                    }
                  },
                  obscureText: isPassword!,
                  readOnly: widget.isReadOnly!,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: widget.label,
                      hintText: widget.placeholder,
                      // isDense: true,
                      prefix:
                          widget.prefix != null ? Text(widget.prefix!) : null,
                      hintStyle:
                          TextStyle(fontSize: widget.smallVersion! ? 12 : 15)),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  isPassword = !isPassword!;
                }),
                child: widget.password!
                    ? Container(
                        width: fieldHeight,
                        height: fieldHeight,
                        alignment: Alignment.center,
                        child: Icon(isPassword!
                            ? Icons.visibility
                            : Icons.visibility_off))
                    : Container(),
              ),
              GestureDetector(
                onTap: widget.suffixFunction,
                child: widget.suffix != null
                    ? Container(
                        padding: EdgeInsets.only(left: 5),
                        // width: fieldHeight,
                        // height: fieldHeight,
                        alignment: Alignment.center,
                        child: Text(
                          widget.suffix!,
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ))
                    : Container(),
              ),
            ],
          ),
        ),
        if (widget.validationMessage != null)
          NoteText(
            widget.validationMessage!,
            color: Colors.red,
          ),
        if (widget.additionalNote != null) verticalSpace(5),
        if (widget.additionalNote != null) NoteText(widget.additionalNote!),
        verticalSpaceSmall
      ],
    );
  }
}
