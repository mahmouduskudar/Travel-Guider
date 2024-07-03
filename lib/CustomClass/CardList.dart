import 'package:bitirmes/Features/FeatureSelection.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProjectPadding.FavoritePadding,
      child: Card(
        elevation: 5,
        color: ColorItems.newsWidgetBackGroundColor,
        shadowColor: ColorItems.newsCardShadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: child,
      ),
    );
  }
}
