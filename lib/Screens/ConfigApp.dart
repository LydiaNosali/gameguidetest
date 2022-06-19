import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:launch_review/launch_review.dart';
import 'package:rate_my_app/rate_my_app.dart';
//import 'package:firebase_admob/firebase_admob.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../main.dart' as mainPage;

int _nbClic = 0; // control click on banner Ads
int _nbClicInterAds = 0; //control click on interstitial Ads

int get nbClic => _nbClic;
int get nbClicInterAds => _nbClicInterAds;

final GlobalKey<State> _keyLoader = new GlobalKey<State>();

class configure {
  //--------------------------------------------------------------------
  static const Color color1 = Color(0xff4a45e6);
  static const Color color2 = Color(0xff0aefa); //loading color

  late BannerAd myBanner;
  late InterstitialAd myInterstitial;
  //SharedPreferences prefs ;
  // var firestoreInstance = FirebaseFirestore.instance;
  /* ShowBanner() async {
    FirebaseAdMob.instance.initialize(appId: mainPage.app_id).then((response) {
      myBanner = BannerAd(
        adUnitId:  mainPage.ad_banner,
        size: AdSize.smartBanner,
        listener: (MobileAdEvent event) async  {
            print("BannerAd event is $event");
            if (event == MobileAdEvent.opened) {
              _nbClic++;
            } else if (event == MobileAdEvent.closed &&(_nbClic >= 2) ) {
              //myBanner ..load()..show(anchorOffset: -60);
              myBanner.dispose();
              myBanner = null;

            }
        },
      );
        // typically this happens well before the ad is shown
      myBanner ..load()
        ..show(
          // Positions the banner ad 60 pixels from the bottom of the screen
          anchorOffset: 0.0,
          // Banner Position
          anchorType: AnchorType.bottom,

        );
    });
  } */

//for show inters
  /*ShowIntert() async {
      myInterstitial = InterstitialAd(
      adUnitId: mainPage.ad_full,
      listener: (MobileAdEvent event) {

        if((event == MobileAdEvent.opened) & (nbClicInterAds >= 2 )){
          myInterstitial.dispose();
          myInterstitial = null;
        }
        if (event == MobileAdEvent.clicked) {
          _nbClicInterAds++;

        }
        if ((event == MobileAdEvent.closed ) & (nbClicInterAds >= 2 ) ) {

          myInterstitial.dispose();
          myInterstitial = null;
        }
      },
    );
    FirebaseAdMob.instance.initialize(appId: mainPage.app_id).then((response) {
      myInterstitial

        // typically this happens well before the ad is shown
        ..load()
        ..show();
    });
  }
*/
  ShowIntert() async {
    print(mainPage.ad_full);
    InterstitialAd.load(
      adUnitId: 
          mainPage.ad_full, // replace with your Admob Interstitial ad Unit ID
      request: AdRequest(),
      adLoadCallback:
          InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
        myInterstitial = ad;
      }, onAdFailedToLoad: (LoadAdError error) {
        print('InterstitialAd failed to load: $error');
      }),
    );
    myInterstitial.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
      print('%ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
      print('$ad onAdDismissedFullScreenContent.');
      ad.dispose();
  },
  onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
    print('$ad onAdFailedToShowFullScreenContent: $error');
    ad.dispose();
  },
  onAdImpression: (InterstitialAd ad) => print('$ad impression occurred.'),);
  myInterstitial.show();
  }
  
  ///
  void rateMyApplication(context) {
    RateMyApp rateMyApp = RateMyApp(
      preferencesPrefix: 'rateMyApp_',
      minDays: 7,
      minLaunches: 10,
      remindDays: 7,
      remindLaunches: 10,
      googlePlayIdentifier: mainPage.linkapp_rate,
      appStoreIdentifier: '375380948',
    );
    rateMyApp.init().then((_) {
      rateMyApp.showStarRateDialog(
        context, // The dialog title.
        message: 'Help us with your feedback', // The dialog message.
        // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
        actionsBuilder: (context, stars) {
          // Triggered when the user updates the star rating.
          return [
            // Return a list of actions (that will be shown at the bottom of the dialog).
            FlatButton(
              child: Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF284B63),
                  fontSize: 20,
                ),
              ),
              onPressed: () async {
                print('Thanks for the ' +
                    (stars == null ? '0' : stars.round().toString()) +
                    ' star(s) !');
                // You can handle the result as you ant (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
                // This allows to mimic the behavior of the default "Rate" button. See "Advanced > Broadcasting events" for more information :
                if (stars != null) {
                  if (stars.round() <= 2) {
                    Navigator.pop<RateMyAppDialogButton>(
                        context, RateMyAppDialogButton.rate);
                    _ackAlert(context);
                  }
                } else {
                  LaunchReview.launch(
                      androidAppId: rateMyApp.googlePlayIdentifier,
                      iOSAppId: rateMyApp.appStoreIdentifier);
                  await rateMyApp
                      .callEvent(RateMyAppEventType.rateButtonPressed);
                  Navigator.pop<RateMyAppDialogButton>(
                      context, RateMyAppDialogButton.rate);
                }
              },
            ),
          ];
        },
        dialogStyle: DialogStyle(
          // Custom dialog styles.
          titleAlign: TextAlign.center,
          messageStyle: TextStyle(
            fontSize: 20,
            fontFamily: "caviar-dreams-bold",
            color: Color(0xFF284B63),
          ),
          messageAlign: TextAlign.center,
          dialogShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          messagePadding: EdgeInsets.only(bottom: 20),
        ),
        title: "",
        starRatingOptions: StarRatingOptions(
            // starsBorderColor: Colors.yellow,
            // starsFillColor: Colors.yellow,
            ), // Custom star bar rating options.
        onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
            .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
      );
    });
  }
}

Future getAdmobid() async {
  var firstore = FirebaseFirestore.instance;
  QuerySnapshot qn = await firstore.collection("adsConfig").get();
  return qn.docs;
}

//Creating static function to for App loading indicator
Future _ackAlert(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text('Thank you for your feedback',
            style: TextStyle(fontSize: 18, color: Colors.black)),
        actions: [
          FlatButton(
            child: Text('Ok',
                style: TextStyle(
                  fontSize: 18,
                )),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
