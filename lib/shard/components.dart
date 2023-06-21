import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultTextFormField extends StatefulWidget {
  final String hintText;
  final TextInputType? textInputType;
  final Widget? prefixIcon;
  final bool obscureText;
  final TextEditingController controller;
  final Function validator;
  final TextInputAction actionKeyboard;
  final Function? onSubmitField;
  final Function? onFieldTap;

  const DefaultTextFormField(
      {required this.hintText,
        this.textInputType,
        this.obscureText = false,
        required this.controller,
        required this.validator,
        this.actionKeyboard = TextInputAction.next,
        this.onSubmitField,
        this.onFieldTap,
        this.prefixIcon});

  @override
  _DefaultTextFormFieldState createState() => _DefaultTextFormFieldState();
}

class _DefaultTextFormFieldState extends State<DefaultTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.textInputType,
      obscureText: widget.obscureText,
      validator: (value){
        print('value $value');
          widget.validator;
      },
      onTap: (){
        if(widget.onFieldTap != null) {
          widget.onFieldTap!();
        }
      },
      onFieldSubmitted: (value){
        if(widget.onSubmitField != null) {
          widget.onSubmitField!();
        }
      },
      textInputAction: widget.actionKeyboard,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        border: OutlineInputBorder()
      ),


    );
  }
}
