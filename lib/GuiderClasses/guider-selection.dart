import 'package:bitirmes/CustomClass/TextWidget.dart';
import 'package:bitirmes/Features/FeatureSelection.dart';
import 'package:bitirmes/GuiderClasses/guider_details.dart';
import 'package:bitirmes/ObjectClasses/customer.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class GuiderSelectionPage extends StatelessWidget {
  final MapPlace place;
  List<String>? get imageList => place.images;

  GuiderSelectionPage(this.place);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            if (imageList != null)
              SizedBox(
                height: 300,
                child: CarouselSlider(
                  options: CarouselOptions(height: 300),
                  items: imageList!.map(
                    (name) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 2.0),
                            decoration:
                                const BoxDecoration(color: Colors.transparent),
                            child: Image.network(name),
                          );
                        },
                      );
                    },
                  ).toList(),
                ),
              ),
            Expanded(
              child: Padding(
                padding: ProjectPadding.pagePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      place.name ?? "",
                      style: ThemeClass.headline1,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      // the decraption under the title
                      place.desc ?? "",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: ThemeClass.headline3,
                    ),
                    SizedBox(
                      width: 130,
                      height: 40,
                      child: Divider(
                        thickness: 2.3,
                      ),
                    ),
                    Expanded(child: GuiderSelectionWidget(place: place)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GuiderSelectionWidget extends StatelessWidget {
  final MapPlace place;

  GuiderSelectionWidget({required this.place});

  @override
  Widget build(BuildContext context) {
    final guiders = place.guiders ?? [];
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemCount: guiders.length,
      itemBuilder: (BuildContext context, int index) {
        final guider = guiders[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return GuiderDetailesScreen(
                    guider: guider,
                    place: place,
                  );
                },
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            color: ColorItems.newsWidgetBackGroundColor,
            shadowColor: ColorItems.newsCardShadowColor,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GuiderImage(guider: guider),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          guider.fullName ?? '',
                          maxLines: 1,
                          style: ThemeClass.headline3,
                        ),
                        const SizedBox(height: 8),
                        GuiderRating(
                          guider: guider,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class GuiderImage extends StatelessWidget {
  final Guider guider;
  final bool isbig;
  const GuiderImage({
    super.key,
    required this.guider,
    this.isbig = false,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final imgStr = guider.guiderImage;

        return CircleAvatar(
          backgroundImage: imgStr == null
              ? null
              : NetworkImage(
                  imgStr,
                ),
          radius: isbig ? 65 : 40,
          backgroundColor: ColorItems.projectBlue,
        );
      },
    );
  }
}

class GuiderRating extends StatelessWidget {
  final Guider guider;
  const GuiderRating({
    super.key,
    required this.guider,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final rt = guider.rating;
        final rating = rt == null ? 0.0 : double.tryParse(rt) ?? 0.0;
        return RatingBarIndicator(
          rating: rating,
          itemBuilder: (context, index) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          itemCount: 5,
          itemSize: 40.0,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
