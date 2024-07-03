import 'package:bitirmes/Features/FeatureSelection.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    Key? key,
    this.text = "",
    this.bckgrnd = Colors.white60,
    required this.sizeHeight,
    required this.controllerParam,
    this.hideInput = false,
    this.keyboardType,
    this.maxLines = 1,
  }) : super(key: key);

  final String text;
  final Color bckgrnd;
  final double sizeHeight;
  final TextEditingController controllerParam;
  final bool hideInput;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
      child: SizedBox(
        height: sizeHeight / 12,
        child: TextFormField(
          obscureText: hideInput,
          controller: controllerParam,
          cursorRadius: Radius.circular(10),
          decoration: InputDecoration(
            hintText: text,
            filled: true,
            fillColor: bckgrnd,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                width: 3,
                color: Colors.greenAccent,
              ),
            ),
          ),
          maxLines: maxLines,
          keyboardType: keyboardType,
        ),
      ),
    );
  }
}

class UnderlinedTextFieldWidget extends StatelessWidget {
  UnderlinedTextFieldWidget({
    Key? key,
    required this.message,
    this.hideInput = false,
    required this.controllerParam,
  }) : super(key: key);
  final String message;
  final bool hideInput;
  final TextEditingController controllerParam;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProjectPadding.EditPadding,
      child: TextFormField(
        obscureText: hideInput,
        controller: controllerParam,
        decoration: InputDecoration(
          hintText: message,
          hintStyle: TextStyle(fontSize: 20.0, color: Colors.black26),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
