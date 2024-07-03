import 'package:bitirmes/Features/FeatureSelection.dart';
import 'package:bitirmes/ObjectClasses/customer.dart';
import 'package:bitirmes/UserLogin-Register/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../GuiderClasses/guider-selection.dart';

class favoritePage extends StatefulWidget {
  @override
  State<favoritePage> createState() => _favoritePageState();
}

class _favoritePageState extends State<favoritePage> {
  var favoriteLocations = <MapPlace>[];

  @override
  void initState() {
    super.initState();
    allFavoritePlaces();
  }

  Future<void> allFavoritePlaces() async {
    await EasyLoading.show(status: 'Loading...');

    var bodyStr = await LoginFormPage.currentCustomer.listAllFavoritePlaces();
    setState(() {
      favoriteLocations = bodyStr ?? [];
    });
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorItems.projectBackground,
      appBar: AppBar(
        title: const Text(
          'Favorites',
        ),
      ),
      body: ListView.separated(
        itemCount: favoriteLocations.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey,
          thickness: 1,
        ),
        itemBuilder: (BuildContext context, int index) {
          String? imgUrl;
          final imgs = favoriteLocations[index].images;
          if (imgs != null && imgs.length > 0) {
            imgUrl = imgs[0];
          }
          return FavoriteItem(
            imageUrl: imgUrl,
            name: favoriteLocations[index].name ?? '',
            place: favoriteLocations[index],
            onDelete: () async {
              var bodyStr = await LoginFormPage.currentCustomer.deleteFavorite(
                favoriteLocations[index].id,
              );
              print(bodyStr);
              if (bodyStr["status"] == 1) {
                EasyLoading.showSuccess('Deleted Success!');
                setState(() {
                  favoriteLocations.removeAt(index);
                });
              } else {
                EasyLoading.showError(bodyStr["message"]);
              }
            },
          );
        },
      ),
    );
  }
}

class FavoriteItem extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final MapPlace place;

  final void Function() onDelete;

  const FavoriteItem({
    Key? key,
    required this.name,
    required this.onDelete,
    required this.imageUrl,
    required this.place,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return GuiderSelectionPage(place);
            },
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              if (imageUrl != null) ...[
                SizedBox(
                  height: 90,
                  width: 90,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: onDelete,
                            icon: const Icon(
                              Icons.close,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
