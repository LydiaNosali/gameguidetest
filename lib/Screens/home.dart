import 'package:flutter/material.dart';
import 'package:guidegametest/main.dart' as mainPage;
import 'package:launch_review/launch_review.dart';
import 'package:flutter_share/flutter_share.dart';
import 'Contentdata.dart';
import 'ConfigApp.dart';

void main() => runApp(new MaterialApp(
      home: new HomeScreen(),
    ));

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  get setting => configure();
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
           primaryColor: configure.color1,
          ),
      home: Scaffold(
        //App Bar
        appBar: new AppBar(
          backgroundColor: configure.color1,
          bottomOpacity: 0.0,
          elevation: 0.0,
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.card_giftcard),
              onPressed: () {
                 LaunchReview.launch(androidAppId: mainPage.linkstore_moreapps);
              },
            ),
            new IconButton(
              icon: new Icon(Icons.share),
              onPressed: () {
               //  Share.share( mainPage.linkapp_share);
              },
            ),
          ],
        ),
        //Content of tabs
        body: ContentData(),
      ),
    );
  }
}
