import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:guidegametest/screens/onboarding_screen.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

String _app_name = "";
String _app_id = "";
String _ad_banner = "";
String _ad_full = "";
String _ad_native = "";
String _ad_reward = "";
String _linkapp_share = ""; //Show Image cover
String _linkapp_rate = "";
String _linkstore_moreapps = ""; //ID for send trafiic to other app like gift
var firestoreInstance = FirebaseFirestore.instance;

String get app_name => _app_name; // To ensure readonly
String get app_id => _app_id; // To ensure readonly
String get ad_banner => _ad_banner; // To ensure readonly
String get ad_full => _ad_full; // To ensure readonly
String get ad_native => _ad_native; // To ensure readonly
String get ad_reward => _ad_reward; // To ensure readonly
String get linkapp_share => _linkapp_share; // To ensure readonly
String get linkapp_rate => _linkapp_rate; // To ensure readonly
String get linkstore_moreapps => _linkstore_moreapps; // To ensure readonly

Future getAdmobConfig() async {
   firestoreInstance.collection("adsConfig").get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
       _app_name = result.data()["app_name"];
      _app_id = result.data()["app_id"];
      _ad_banner = result.data()["ad_banner"];
      _ad_full = result.data()["ad_full"];
      _linkapp_share = result.data()["linkapp_share"];
      _ad_native = result.data()["ad_native"];
      _ad_reward = result.data()["ad_reward"];
      _linkapp_rate = result.data()["linkapp_rate"];
      _linkstore_moreapps = result.data()["linkstore_moreapps"];
    });
  });
 //var res = await firestoreInstance.collection("adsConfig").get();
  /*if (res.docs != null && res.docs.isNotEmpty) {
    res.docs.forEach((result) {
      print('ouiiii');
      _app_name = result.data()["app_name"];
      _app_id = result.data()["app_id"];
      _ad_banner = result.data()["ad_banner"];
      _ad_full = result.data()["ad_full"];
      _linkapp_share = result.data()["linkapp_share"];
      _ad_native = result.data()["ad_native"];
      _ad_reward = result.data()["ad_reward"];
      _linkapp_rate = result.data()["linkapp_rate"];
      _linkstore_moreapps = result.data()["linkstore_moreapps"];
      print(result.data());
    });
  } else {
    print("No such document");
  }*/
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new SplashScreenc(),
  ));
}

class SplashScreenc extends StatefulWidget {
  //SplashScreenc({required Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenc> {
  /* Future getAdsremotData() async {
    var response = await http.get(Uri.parse(
        'https://6129a54f068adf001789b8d8.mockapi.io/api/v1/admoconfi'));
    var jsonData = jsonDecode(response.body);

    List<AdsRemot> adsunits = [];
    for (var u in jsonData) {
      AdsRemot adunit = AdsRemot(
          u['app_name'],
          u["app_id"],
          u["ad_banner"],
          u["ad_full"],
          u["ad_native"],
          u["ad_reward"],
          u["ad_openapp"],
          u["linkapp_share"],
          u["linkapp_rate"],
          u["linkstore_moreapps"]);
      adsunits.add(adunit);
    }
    print(adsunits);
    return adsunits;
  }*/

  @override
  void initState() {
    getAdmobConfig();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          child: Stack(
            children: <Widget>[
              OnboardingScreen()
              //Loading(),
            ],
          ),
        ),
      ),
    );
  }
}
