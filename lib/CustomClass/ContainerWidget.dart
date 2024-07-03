import 'package:flutter/material.dart';

class ContainerWidget extends StatelessWidget {
  const ContainerWidget({
    Key? key,
    required this.cityName,
    required this.date,
    required this.userName,
    required this.price,
  }) : super(key: key);
  final String cityName;
  final String date;
  final String userName;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
