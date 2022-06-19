import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
// import 'package:firebase_admob/firebase_admob.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'ConfigApp.dart';
import 'package:path/path.dart' as Path;
import 'ConfigApp.dart' as Configurations;
// import 'dart:math' as math;
import '../main.dart' as mainPage;

class Pages extends StatefulWidget {
  final List<Widget> pages;
  final settingr = configure();

  @override
  _PagesState createState() => _PagesState();

  Pages({required this.pages});
}

class InterstitialAdManager {
  InterstitialAd? _interstitialAd;
  static int sequence = 3;
  static int sequenceLimit = 3;
  /*static void load() {
    _interstitialAd = InterstitialAd(
      adUnitId:  mainPage.ad_full, //ad unit
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.closed) {
          _interstitialAd?.dispose();
          load();
        }
        if (event == MobileAdEvent.failedToLoad) {
          print("Error code loading admob intersitial");
        }
      },
    );
    _interstitialAd.load();
  } */

  /*static Future<bool> showIters() async {
    if (sequence >= sequenceLimit) {
      if (await _interstitialAd.isLoaded()) {
        _interstitialAd.show();
        sequence = 0;
        return true;
      } else {
        load();
        return false;
      }
    } else {
      sequence++;
      return false;
    }
  }*/
  ShowIntert() async {
    InterstitialAd.load(
      adUnitId:
          mainPage.ad_full, // replace with your Admob Interstitial ad Unit ID
      request: AdRequest(),
      adLoadCallback:
          InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
        _interstitialAd = ad;
      }, onAdFailedToLoad: (LoadAdError error) {
        print('InterstitialAd failed to load: $error');
      }),
    );
  }
}

final GlobalKey<State> _keyLoader = new GlobalKey<State>();
Timer? _timer;

class _PagesState extends State<Pages> {
  Future getPushLinks() async {}
  get setting => configure();

  final _controller = new PageController(
    initialPage: 0,
  );
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  int current = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SingleChildScrollView(
            child: Container(
          height: MediaQuery.of(context).size.height - 290,
          // padding: new EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: _controller,
            itemCount: widget.pages.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  child: SingleChildScrollView(child: widget.pages[index]));
            },
          ),
        )),
        Container(
          padding: new EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                child: Text('Prev',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: "caviar-dreams-bold")),
                onPressed: () {
                  // InterstitialAdManager.showIters();

                  if (current > 1) {
                    setState(() {
                      _controller.previousPage(
                          duration: _kDuration, curve: _kCurve);
                      current--;
                    });
                    switch (current) {
                      case 3:
                      case 6:
                      case 9:
                        print("vous ete à :" + current.toString());
                        //open dialog
                        /* if (Configurations.nbClicInterAds < 2) {
                          Dialogs.showLoadingDialog(context, _keyLoader);
                        }*/
                        setting.ShowIntert();
                        /*_timer = new Timer(const Duration(seconds: 5), () {
                          setState(() {
                            //close the dialog
                            Navigator.of(this.context,
                                    rootNavigator: true)
                                .pop();
                            //show Interstitial Ads
                            
                          });
                        });*/
                        break;
                    }
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30))),
                color: Color.fromRGBO(67, 155, 251, 2),
                padding: EdgeInsets.all(15),
              ),
              MaterialButton(
                child: Text("$current",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: "caviar-dreams-bold")),
                color: Color.fromRGBO(67, 155, 251, 2),
                onPressed: () {},
                padding: EdgeInsets.all(15),
              ),
              MaterialButton(
                child: Text(
                  'Next',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "caviar-dreams-bold"),
                ),
                onPressed: () async {
                  //InterstitialAdManager.showIters();

                  if (current < widget.pages.length) {
                    setState(() {
                      _controller.nextPage(
                          duration: _kDuration, curve: _kCurve);
                      current++;
                    });
                    switch (current) {
                      case 3:
                      case 6:
                      case 9:
                        print("vous ete à :" + current.toString());
                        //open dialog
                      /*if (Configurations.nbClicInterAds < 2) {
                          Dialogs.showLoadingDialog(context, _keyLoader);
                        }*/
                        setting.ShowIntert();
                        /*_timer = new Timer(const Duration(seconds: 5), () {
                          setState(() {
                            //close the dialog
                            Navigator.of(this.context,
                                    rootNavigator: true)
                                .pop();
                            //show Interstitial Ads
                            setting.ShowIntert();
                          });
                        }); */
                        break;
                    }
                  } else {
                    buildRateMyApplication();
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                color: Color.fromRGBO(67, 155, 251, 2),
                padding: EdgeInsets.all(15),
              ),
            ],
          ),
        )
      ],
    );
    //
  }

  void buildRateMyApplication() => widget.settingr.rateMyApplication(context);
}

//Creating static function to for App loading indicator
class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  key: key,
                  backgroundColor: Colors.white,
                  children: <Widget>[
                    Center(
                      child: Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                        ),
                        CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.blue)),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                        ),
                        Center(
                            child: Text(
                          " The content is loading...",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromRGBO(67, 155, 251, 2),
                          ),
                        ))
                      ]),
                    )
                  ]));
        });
  }
}
