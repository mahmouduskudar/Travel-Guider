import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    Key? key,
    required this.text,
    required this.styleParam,
  }) : super(key: key);
  final String text;
  final TextStyle styleParam;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 25, bottom: 5),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          text,
          style: styleParam,
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
