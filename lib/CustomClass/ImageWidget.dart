import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  const IconWidget({
    Key? key,
    required this.isSignPage,
    this.imagePath = "",
    required this.widthSize,
    required this.HeightSize,
  }) : super(key: key);
  final bool isSignPage;
  final String imagePath;
  final double widthSize;
  final double HeightSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isSignPage
          ? EdgeInsets.only(top: 20.0, bottom: 10.0)
          : EdgeInsets.only(top: 0.0),
      child: Image(
          image: AssetImage(imagePath), width: widthSize, height: HeightSize),
    );
  }
}
