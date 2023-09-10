import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:launch_review/launch_review.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';


import '../AdHelper/adshelper.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  bool isLanguageSelected = false;

  Future<void>? _launched;

  late BannerAd _bannerAd;

  bool _isBannerAdReady = false;


  String _url = "https://astros.up.railway.app/data";
  late Stream _stream;
  late http.Response response;
  List<Map<String, dynamic>> people = [];

  String peopleCount = "";

  String _launch = "https://www.google.co.in/search?q=";


  getData() async {
    var url = Uri.parse(_url);
    response = await http.get(url);
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    var itemCount = jsonResponse['people'];

    setState(() {
      people = List<Map<String, dynamic>>.from(itemCount);

    });
    print("-----"+people.toString());
  }






  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    getData();

    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitIdOfHomeScreen,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();

  }


  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 10,
        title: Align(
          alignment: Alignment.center,
          child: Text("People in Space Right Now - ${people.length}",
              style: GoogleFonts.openSans(
                  letterSpacing: 0.8,
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
        centerTitle: true,
      ),

      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns

        ),
        itemCount: people.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _launchURL(people[index]['name']);
            },
            child: Card(
              color: Colors.black12, // Background color
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
              child: SizedBox(
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        people[index]['contentUrl'],
                        height: 130.0,
                        width: 120.0,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          people[index]['name'],
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                        Text(
                          "Craft : " + people[index]['craft'],
                          style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold,color: Colors.white),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),

      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isBannerAdReady)
            Container(
              width: _bannerAd.size.width.toDouble(),
              height: _bannerAd.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd),
            ),
        ],
      ),

    );
  }




  void _launchURL(String search) async =>
      await canLaunch(_launch+search) ? await launch(_launch+search) : throw 'Could not launch ${_launch+search}';
}



