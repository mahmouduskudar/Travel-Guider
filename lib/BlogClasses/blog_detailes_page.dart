import 'package:bitirmes/BlogClasses/blog_page.dart';
import 'package:bitirmes/Features/FeatureSelection.dart';
import 'package:flutter/material.dart';

class NewsDetailesScreen extends StatelessWidget {
  const NewsDetailesScreen({
    super.key,
    required this.model,
  });

  final NewsItemModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          children: [
            Hero(
              tag: 'placeImage${model.imagePath.hashCode}',
              child: Image.network(
                model.imagePath,
              ),
            ),
            Padding(
              padding: ProjectPadding.pagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.title,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    model.desc,
                    style: Theme.of(context).textTheme.headline2,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
