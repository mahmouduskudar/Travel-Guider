import 'package:flutter/material.dart';

class HelpCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help',
        ),
      ),
      body: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool _customTileExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const ExpansionTile(
          title: Text('Booking Services'),
          subtitle: Text('Trailing expansion arrow icon'),
          children: <Widget>[
            ListTile(title: Text('This is tile number 1')),
          ],
        ),
        ExpansionTile(
          title: const Text('Return Policy'),
          subtitle: const Text('Custom expansion arrow icon'),
          trailing: Icon(
            _customTileExpanded
                ? Icons.arrow_drop_down_circle
                : Icons.arrow_drop_down,
          ),
          children: const <Widget>[
            ListTile(title: Text('This is tile number 2')),
          ],
          onExpansionChanged: (bool expanded) {
            setState(() => _customTileExpanded = expanded);
          },
        ),
      ],
    );
  }
}

/*
class HelpCenter extends StatelessWidget {
  const HelpCenter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Help',
        ),
      ),
      body: Padding(
        padding: ProjectPadding.pagePadding,
        child: ListView(children: const [
          HelpWidget(
            desc: 'Hello',
          ),
          HelpWidget(
            desc: 'hello ',
          ),
        ]),
      ),
    );
  }
}

class HelpWidget extends StatelessWidget {
  const HelpWidget({
    Key? key,
    required this.desc,
  }) : super(key: key);
  final String desc;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.blueGrey,
      onTap: () => debugPrint('tapped'),
      child: Card(
        elevation: 5,
        color: ColorItems.newsWidgetBackGroundColor,
        shadowColor: ColorItems.newsCardShadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          width: 400,
          height: 70,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.transparent,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(width: 1, color: Colors.transparent),
                  ),
                  child: ClipRRect(
                    // to give an image radius value
                    borderRadius: BorderRadius.circular(30),
                  ),
                ), // suppose the image width is 200
                Expanded(
                  // then, Expanded will tell the Column that its max width would be screensize-200
                  child: Padding(
                    padding: ProjectPadding.newsWisgetPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          desc,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style:
                              //NewsScreenStyle.descraptionStyle,
                              ThemeClass.headline2,
                        ),
                        Icon(Icons.add_circle_outline_sharp),
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
*/