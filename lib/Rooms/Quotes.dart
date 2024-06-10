import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


import 'package:http/http.dart'as http;
import 'package:quoteapp/Rooms/Bookmark.dart';
class Quotes extends StatefulWidget {
  const Quotes({super.key});

  @override
  State<Quotes> createState() => _QuotesState();
}


class _QuotesState extends State<Quotes> {
  @override


  // BannerAd? _bannerAd;
  BannerAd? _inlineAdaptiveAd;
  bool _isLoaded = false;
  AdSize? _adSize;
  static const _insets = 16.0;
  InterstitialAd? _interstitialAd;

  double get _adWidth => MediaQuery.of(context).size.width - (2 * _insets);


  var _Quotes = "Loading...!";
  var _AUTH = FirebaseAuth.instance.currentUser;
  var _DB = FirebaseDatabase.instance.ref("USERS");
  Future getQuotes()async{

    final response  = await http.get(Uri.parse("https://api.kanye.rest"));
    var data = jsonDecode(response.body.toString());

    if(response.statusCode == 200){

      _Quotes = data['quote'];
      setState(() {

      });
      print(_Quotes);
    }
  }

  void loadAd() {
    InterstitialAd.load(
        adUnitId: "ca-app-pub-4850381439154359/3653802109",
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));

  }




  @override
  void initState() {
    getQuotes();
    // _bannerAd?.load();
    super.initState();
  }



  Widget build(BuildContext context) {

    return  SafeArea(
      child: Scaffold(

           
        backgroundColor: Colors.black,
        appBar: AppBar(
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InkWell(
                      onTap: (){
                        if(_AUTH!=null){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const BookMark(),));
                        }else{
                          showDialog(context: context, builder:  (context) {

                            return AlertDialog(
                              icon: Icon(Icons.warning_outlined,color: Colors.red,size: 30,),
                              content: Text("Go to BookMark and First Setup your Account. Than Save these Quotes for Lifetime. Keep in Mind "
                                  "Your All Details are 100% Safe And Secure so Don't Worry About this."),
                              title:Text("Login First!") ,
                            );
                          },);
                        }
                      },
                      child: Icon(Icons.bookmark_added,color: Colors.white,)),
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                      onTap: (){
                        showDialog(context: context, builder:  (context) {

                          return AlertDialog(
                              icon: Icon(Icons.perm_device_info,color: Colors.green,size: 30,),
                              content: Text("Enjoy Free Unlimited Quotes And share with your friends"),
                              title:Text("Guide")
                          );
                        },);
                      },
                      child: Icon(Icons.info,color: Colors.white,)),
                ),
              ],
            ),


          ],
          leading: IconButton(onPressed: (){Navigator.pop(context);}, icon:const Icon(Icons.arrow_back_rounded,color: Colors.white,)),
          backgroundColor: Colors.black,
          title: Text("Quotes" ,style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Text("\"$_Quotes",style: TextStyle(color: Colors.yellow,fontWeight: FontWeight.bold,fontSize: 28,fontFamily:'Teko'),)),
                SizedBox(height: 60,),
                Center(child: Text("~Written With ❤️ By NK Dev",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 11),)),
                SizedBox(height: 25,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  InkWell(
                      onTap: (){
                        if(_AUTH!=null){

                          Random RND = Random();
                          var RNDS = RND.nextInt(1000000)*10;

                          _DB.child(_AUTH!.uid.toString())
                          .child("Saved")
                          .update({
                            "Saves$RNDS" : _Quotes,
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Post Saved")));

                        }else{
                          showDialog(context: context, builder:  (context) {

                            return AlertDialog(
                              icon: Icon(Icons.warning_outlined,color: Colors.red,size: 30,),
                              content: Text("Go to BookMark and First Setup your Account. Than Save these Quotes for Lifetime. Keep in Mind "
                                  "Your All Details are 100% Safe And Secure so Don't Worry About this."),
                              title:Text("Login First!") ,
                            );
                          },);
                        }
                      },
                      child: Icon(Icons.favorite_border,color: Colors.red,size: 54,)),
                    SizedBox(width: 12,),

                    InkWell(
                        onTap: (){
                          _interstitialAd?.show();

                          Clipboard.setData(ClipboardData(text:_Quotes));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Post Copied")));
                        },
                        child: Icon(Icons.copy,color: Colors.lightBlue,size: 54,)),

                    SizedBox(width: 12,),
                  InkWell(
                    splashColor: Colors.black,
                      onTap: (){
                        _interstitialAd?.show();

                        getQuotes();

                        setState(() {

                        });
                      },
                      child: Icon(Icons.next_plan_sharp,color: Colors.green,size: 55,))
                ],),


                SizedBox(height: 20),


              ],
            ),
          ),
        ),
      ),
    );
  }
}