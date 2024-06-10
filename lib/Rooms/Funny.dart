import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart'as http;
class Funny extends StatefulWidget {
  const Funny({super.key});

  @override
  State<Funny> createState() => _FunnyState();

}

class _FunnyState extends State<Funny> {

  // API JOB

  var _JOKE = "Finding Best Jokes For You...";
  var _PUNCHLINE = "Please wait..!";
  BannerAd? _inlineAdaptiveAd;
  bool _isLoaded = false;
  AdSize? _adSize;
  static const _insets = 16.0;

  double get _adWidth => MediaQuery.of(context).size.width - (2 * _insets);
  // Future Mehtod
  Future getQuotes() async{

    final response  =await http.get(Uri.parse("https://official-joke-api.appspot.com/random_joke"));

    var data = jsonDecode(response.body.toString());

    if(response.statusCode == 200){
      _JOKE = data['setup'];
      _PUNCHLINE = data['punchline'];
      setState(() {

      });
      print(_JOKE);

      print(_PUNCHLINE);
    }
  }

  
  @override
  void initState() {

    getQuotes();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
         
          appBar: AppBar(

            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(Icons.bookmark_added,color: Colors.white,),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                        onTap: (){
                          showDialog(context: context, builder:  (context) {

                            return AlertDialog(
                                icon: Icon(Icons.perm_device_info,color: Colors.green,size: 30,),
                                content: Text("These Are Just Jokes. \nIf you notice something wrong report us Please.!Thanks"),
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
            title: Text("Funny" ,style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
          ),
          body: SingleChildScrollView(
            child: Column(

              children:
            [

               Padding(
                 padding: const EdgeInsets.symmetric(vertical: 20),
                 child: Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 8),
                   child: Stack(

                    children: [

                      Center(
                        child: Material(
                          color: Colors.transparent,
                          elevation: 20,

                          child: Container(
                            height: 260,
                            width: 410,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(20)
                            ),
                          ),
                        ),

                      ),
      Center(
        child: Material(
            color: Colors.transparent,
            child: Container(
              height: 250,
              width: 408,
              decoration: BoxDecoration(
                      color: Colors.deepPurple.shade600,
                      borderRadius: BorderRadius.circular(20)
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25,horizontal: 20),
                        child: Align(
                          alignment: Alignment.center,
                          child: SingleChildScrollView(
                            child: Container(
                              height: 26,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: Center(child: Text("Jokes of the Day 😆",style: TextStyle(color: Colors.black,fontSize: 16),))),
                          ),
                        ),
                      ),

                      Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(_JOKE,textDirection: TextDirection.ltr,style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),),
                          )),
                      SizedBox(height: 4,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                          alignment: Alignment.center,
                            child: Text(_PUNCHLINE,style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),)),
                      ),


                      SizedBox(height: 50,),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height:42,
                              width: 130,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("More",style:TextStyle(color: Colors.red)),
                                  SizedBox(width: 5,),
                                 IconButton(onPressed: (){
                                   getQuotes();
                                   }, icon:  Icon(Icons.next_plan_outlined,color: Colors.red,))
                                ],
                              )
                            ),

                            Container(
                              height:42,
                              width: 130,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Copy",style:TextStyle(color: Colors.green)),
                                  SizedBox(width: 5,),
                                  InkWell(
                                      onTap: (){
                                        Clipboard.setData(ClipboardData(text:"${_JOKE + _PUNCHLINE}"));
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Post Copied")));
                                      },
                                      child: Icon(Icons.copy,color: Colors.green,))
                                ],
                              ),
                            ),
                          ],
                        ),
                      )

                  ],
                ),
              )
            ),
        )),

                    ],
              ),
                 ),
               ),

            ],),
          ),
        ));
  }
}
