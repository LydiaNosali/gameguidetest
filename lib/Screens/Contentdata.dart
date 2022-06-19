import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../Model/Modeldata.dart';
import 'ConfigApp.dart';
import 'Navigationdata.dart';

class ContentData extends StatefulWidget {
  //final Function rateMyApp;
  @override
  _ContentDataState createState() => _ContentDataState();
}

class _ContentDataState extends State<ContentData> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: configure.color1,
      ),
      home: Scaffold(
          body: Center(
        child: Container(
            child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              color: configure.color1,
              height: 90,
              child: Padding(
                padding: EdgeInsets.only(top: 2),
                child: Text(
                  "Totok Guide",
                  //  a.app_name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: "caviar-dreams-bold"),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  color: Colors.transparent,
                  height: 55,
                  width: double.infinity,
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(40)),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 70, right: 70, bottom: 30),
                            child: Container(
                              height: 5,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(50),
                                      bottom: Radius.circular(50))),
                            )),
                        Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Container(
                              child: FutureBuilder(
                                future: rootBundle
                                    .loadString('assets/guidedata.json'),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    var articles =
                                        articlesListFromJson(snapshot.data);
                                    return Pages(
                                        pages: articles.articles
                                            .map(
                                              (articles) => Container(
                                                child: Column(
                                                  children: <Widget>[
                                                    Text(
                                                      articles.title,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontSize: 25,
                                                        fontFamily:
                                                            "caviar-dreams-bold",
                                                        color:
                                                            Color(0xFF284B63),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    // Image.network( articles.image),
                                                    HtmlWidget(
                                                      articles.content,
                                                      webView: true,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList());
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                },
                              ),
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        )),
      )),
      //ADS
    );
  }
}
