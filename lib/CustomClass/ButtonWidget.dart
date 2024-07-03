import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    Key? key,
    required this.text,
    required this.pressedKey,
    required this.styleParam,
  }) : super(key: key);
  final String text;
  final void Function()? pressedKey;
  final ButtonStyle styleParam;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: styleParam.copyWith(
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
        ),
      ),
      onPressed: pressedKey,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
