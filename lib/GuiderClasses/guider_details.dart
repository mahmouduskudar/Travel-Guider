import 'package:bitirmes/GuiderClasses/guider-booking.dart';
import 'package:bitirmes/ObjectClasses/customer.dart';
import 'package:bitirmes/UserProfileClasses/edit_profile_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../chat/chat_screen.dart';
import 'guider-selection.dart';

class GuiderDetailesScreen extends StatelessWidget {
  final Guider guider;
  final MapPlace place;

  const GuiderDetailesScreen({
    Key? key,
    required this.guider,
    required this.place,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 120, top: 50, right: 100),
                  child: GuiderImage(
                    guider: guider,
                    isbig: true,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GuiderRating(
                  guider: guider,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  guider.fullName ?? '',
                  maxLines: 2,
                  style:
                      //NewsScreenStyle.titleStyle,
                      Theme.of(context).textTheme.headline4,
                ),
                Text(
                  'Guider',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  //style: Theme.of(context).textTheme.headline2,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoginButtonWidget(
                      text: 'Chat',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              userId: guider.id!,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    LoginButtonWidget(
                      text: 'Book',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GuiderBookingScreen(
                              guider: guider,
                              placeId: place.id!,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Text(
                    guider.bio ?? '',
                    maxLines: 2,
                    style:
                        //NewsScreenStyle.titleStyle,
                        Theme.of(context).textTheme.headline5,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (guider.dailyPrice != null)
                            Text(
                              'Price Per Day : \$${guider.dailyPrice!}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          Text(
                            'Working Days: ' + guider.workingDaysStr,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Center(
                      child: Text(
                        'My Photos',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        final imgs = guider.images;

                        if (imgs == null || imgs.isEmpty) {
                          return const SizedBox();
                        }

                        return CarouselSlider(
                          options: CarouselOptions(height: 300.0),
                          items: imgs.map(
                            (imgPath) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                    ),
                                    child: Image.network(imgPath),
                                  );
                                },
                              );
                            },
                          ).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
