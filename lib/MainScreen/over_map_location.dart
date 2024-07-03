import 'dart:async';

import 'package:bitirmes/GuiderClasses/guider-selection.dart';
import 'package:bitirmes/ObjectClasses/customer.dart';
import 'package:bitirmes/UserLogin-Register/sign_in_page.dart';
import 'package:bitirmes/UserProfileClasses/favorite_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

// ignore: must_be_immutable
class OverMapLocation extends StatefulWidget {
  OverMapLocation({
    Key? key,
    required this.place,
    required this.isFavorite,
  }) : super(key: key);

  final MapPlace place;
  bool isFavorite;

  @override
  State<OverMapLocation> createState() => _OverMapLocationState();
}

class _OverMapLocationState extends State<OverMapLocation> {
  Future<void> setHeartChecked() async {
    widget.isFavorite = !widget.isFavorite;
    print("widget.isFavorite ${widget.isFavorite}");
    if (widget.isFavorite) {
      var bodyStr =
          await LoginFormPage.currentCustomer.addFavorite(widget.place.id);
      if (bodyStr["status"] == 1) {
        EasyLoading.showSuccess(bodyStr["message"]);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => favoritePage()),
        );
      } else {
        EasyLoading.showError(bodyStr["message"]);
      }
      setState(() {});
    } else {
      var bodyStr =
          await LoginFormPage.currentCustomer.deleteFavorite(widget.place.id);
      if (bodyStr["status"] == 1) {
        EasyLoading.showSuccess('Deleted Success!');
      } else {
        EasyLoading.showError(bodyStr["message"]);
      }
      print("on delete");
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => CustomerPanel())); // Sayfayı tekrar push et
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    print('widget.isFavorite: $widget.isFavorite');
    void onCardTap() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return GuiderSelectionPage(widget.place);
          },
        ),
      );
    }

    return GestureDetector(
      onTap: onCardTap,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                //mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisSize: MainAxisSize.min,
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          widget.place.name ?? '',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        Text(
                          [widget.place.area, widget.place.city]
                              .where((element) => element != null)
                              .join(' - '),
                        )
                      ],
                    ),
                  ),
                  IconButton(
                    iconSize: 35,
                    onPressed: setHeartChecked,
                    icon: Icon(widget.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border),
                    color: Colors.red,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(flex: 3, child: Text('Price')),
                  Expanded(
                    flex: 7,
                    child: Text('80/daily'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text('Activity'),
                  ),
                  Expanded(
                    flex: 7,
                    child: Divider(
                      thickness: 2,
                      color: Colors.black,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
