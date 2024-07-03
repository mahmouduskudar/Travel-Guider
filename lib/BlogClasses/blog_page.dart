import 'package:bitirmes/BlogClasses/blog_detailes_page.dart';
import 'package:bitirmes/Features/FeatureSelection.dart';
import 'package:bitirmes/ObjectClasses/blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class NewsScreen extends StatefulWidget {
  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  var locnames = <NewsItemModel>[];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: allBlog(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                'Blog',
              ),
            ),
            body: Padding(
              padding: ProjectPadding.pagePadding,
              child: ListView.builder(
                itemCount: locnames.length,
                itemBuilder: (BuildContext context, int index) {
                  return NewsItemWidget(
                    model: locnames[index],
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> allBlog() async {
    await EasyLoading.show(status: 'Loading...');
    Blog blog = Blog();
    var bodyStr = await blog.listAllPost();
    print(bodyStr);

    if (bodyStr["status"] == 1) {
      final ls = bodyStr["data"];
      final dt = List<Map<String, dynamic>>.from(ls);
      locnames = dt.map((e) => NewsItemModel.fromJson(e)).toList();

      EasyLoading.dismiss();
    } else {
      EasyLoading.showError('Something went wrong!');
    }
  }
}

class NewsItemModel {
  final String title;
  final String desc;
  final String imagePath;

  const NewsItemModel({
    required this.title,
    required this.desc,
    required this.imagePath,
  });

  factory NewsItemModel.fromJson(Map<String, dynamic> json) {
    return NewsItemModel(
      title: json['title'],
      desc: json['body'],
      imagePath: json['img'],
    );
  }
}

class NewsItemWidget extends StatelessWidget {
  const NewsItemWidget({
    Key? key,
    required this.model,
  }) : super(key: key);
  final NewsItemModel model;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: InkWell(
        splashColor: Colors.blueGrey,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetailesScreen(
                model: model,
              ),
            ),
          );
        },
        child: Card(
          elevation: 5,
          color: ColorItems.newsWidgetBackGroundColor,
          shadowColor: ColorItems.newsCardShadowColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  height: 100,
                  child: ClipRRect(
                    // to give an image radius value
                    borderRadius: BorderRadius.circular(30),
                    child: Hero(
                      tag: 'placeImage${model.imagePath.hashCode}',
                      child: Image.network(
                        model.imagePath,
                      ),
                    ),
                  ),
                ), // suppose the image width is 200
                Expanded(
                  // then, Expanded will tell the Column that its max width would be screensize-200
                  child: Padding(
                    padding: ProjectPadding.newsWisgetPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.title,
                          maxLines: 1,
                          style:
                              //NewsScreenStyle.titleStyle,
                              ThemeClass.headline2,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          model.desc,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style:
                              //NewsScreenStyle.descraptionStyle,
                              ThemeClass.headline4,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
