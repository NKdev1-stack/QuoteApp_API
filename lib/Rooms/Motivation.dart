import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quoteapp/Rooms/Bookmark.dart';
import 'package:shimmer/shimmer.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quoteapp/Models/MT_QUOTES.dart';
import 'package:http/http.dart'as http;

import '../Toast.dart';
class Motivation extends StatefulWidget {
  const Motivation({super.key});

  @override
  State<Motivation> createState() => _MotivationState();
}

class _MotivationState extends State<Motivation> {

// BannerAd? _bannerAd;
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  InterstitialAd? _interstitialAd;

  void _loadAd() {
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


  //DB

  final _Auth = FirebaseAuth.instance.currentUser;
  final _DB = FirebaseDatabase.instance.ref("USERS");



  // Future Method

  // API JOB
  List<MtQuotes> _MOTIVATIOIN_QUOTE_LIST = [];
  Future<List<MtQuotes>> _getMTQuotes() async{

    final response = await http.get(Uri.parse("https://zenquotes.io/api/quotes"));

    var data = jsonDecode(response.body.toString());

    if(response.statusCode == 200){


      _MOTIVATIOIN_QUOTE_LIST.clear();
      // Loop for adding data in List using  Model
      for(Map i in data){
        
        _MOTIVATIOIN_QUOTE_LIST.add(MtQuotes.fromJson(i));
      }

      return _MOTIVATIOIN_QUOTE_LIST;

    }else{
      return _MOTIVATIOIN_QUOTE_LIST;
    }


  }

  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: "ca-app-pub-4850381439154359/4966883777",
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }


  @override
  void initState() {
    loadAd(); // For Admob interestitial ads
    _loadAd(); // for Admob Banner Ads
    _getMTQuotes();
    super.initState();
  }
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      bottomNavigationBar: Container(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
      appBar: AppBar(

        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(

                    onTap: (){

                      if(_Auth!=null){
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
                          content: Text("Scroll Down to Get More Quotes!.\nBookMark your Favourite Quotes For Later. \nEnjoy Your Life"),
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
        title: Text("Motivation" ,style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
      ),
      body: RefreshIndicator(
        onRefresh: ()async{
          setState(() {

          });
        },
        child: Column(

          children: [



          Expanded(
            child: FutureBuilder(
              future: _getMTQuotes(),
              builder: (context, snapshot) {

               if(!snapshot.hasData){
                 return ListView.builder(
                   itemBuilder: (context, index) {
                     return Shimmer.fromColors(
                         baseColor: Colors.grey.shade400,
                         highlightColor: Colors.grey.shade100,
                         child:  Column(
                           children: [

                             ListTile(

                               title: Container(height: 20,width: 89,color: Colors.white,),
                               leading: Container(height: 50,width: 89,color: Colors.white,),
                               subtitle: Container(height: 10,width: 89,color: Colors.white,),

                             )

                           ],)

                     );



                   },);

               }else{
                 return ListView.builder(
                   itemCount: _MOTIVATIOIN_QUOTE_LIST.length,
                   itemBuilder: (context, index) {


                     if(index % 4 == 3) {
                      // Use this to return ads show ads in list views
                     }
                     return Column(
                       children: [

                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Card(
                             elevation: 10,
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               crossAxisAlignment: CrossAxisAlignment.center,
                               children: [

                                 ListTile(
                                   title: Text(_MOTIVATIOIN_QUOTE_LIST[index].q.toString()),
                                   subtitle: Padding(
                                     padding: const EdgeInsets.symmetric(vertical: 5),
                                     child: Text("Author Name:" + _MOTIVATIOIN_QUOTE_LIST[index].a.toString()),
                                   ),
                                   onTap: (){


                                   },
                                   trailing: PopupMenuButton(

                                     itemBuilder: (context) =>
                                     [
                                       PopupMenuItem(

                                           child: ListTile(
                                             onTap:(){
                                               _interstitialAd?.show();

                                               Navigator.pop(context);
                                               Clipboard.setData(ClipboardData(text: _MOTIVATIOIN_QUOTE_LIST[index].q.toString()));
                                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copied Sucessfull",)));

                                             },
                                             title:Text("Copy"),
                                             trailing: Icon(Icons.copy),
                                           )

                                       ),


                                     PopupMenuItem(child: ListTile(
                                       onTap:(){
                                            Navigator.pop(context);
                                         if(_Auth!=null){

                                           Random rnd = Random();
                                           var RNDS = rnd.nextInt(10000000)*100;

                                           _DB.child(_Auth!.uid).child("Saved")
                                               .update({

                                             "Saves$RNDS" : _MOTIVATIOIN_QUOTE_LIST[index].q.toString(),

                                           }).then((value) => {
                                           _interstitialAd?.show(),
                                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Post Saved"))),


                                           }).onError((error, stackTrace) => {

                                           });

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
                                       title: Text("Save"),
                                       trailing: Icon(Icons.bookmark),
                                     ))


                                     ],),
                                   leading: Image.network("https://res.cloudinary.com/dghloo9lv/image/upload/v1687444253/quill-drawing-a-line_n6svbe.png"),
                                 ),




                               ],
                             ),
                           ),
                         )
                       ],
                     );



                   },);
               }


            },),
          )


        ],),
      ),));
  }
}
