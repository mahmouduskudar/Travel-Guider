import 'package:bitirmes/Features/FeatureSelection.dart';

import 'package:flutter/material.dart';

class ListTileWidget extends StatelessWidget {
  const ListTileWidget({
    Key? key,
    required this.text,
    required this.icon,
    this.goToPage,
    this.onPressedAction,
  }) : super(key: key);
  final String text;
  final Icon icon;
  final Widget? goToPage;
  final void Function()? onPressedAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            if (onPressedAction != null) {
              onPressedAction!();
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => goToPage!),
              );
            }
          },
          title: Text(
            text,
            style: TextStyle(fontSize: 20),
          ),
          leading: icon,
        ),
        Padding(
          padding: ProjectPadding.ProfileDividerPadding,
          child: const Divider(
            height: 10,
            thickness: 1,
            indent: 1,
            endIndent: 0,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
