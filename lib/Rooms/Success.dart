import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'Bookmark.dart';
class Success extends StatefulWidget {
  const Success({super.key});

  @override
  State<Success> createState() => _SuccessState();
}

class _SuccessState extends State<Success> {


  bool _isLoaded = false;
  AdSize? _adSize;
  static const _insets = 16.0;

  double get _adWidth => MediaQuery.of(context).size.width - (2 * _insets);


  






  var _QUOTE = "Loading...!";
  var _AUTH = FirebaseAuth.instance.currentUser;
  var _DB = FirebaseDatabase.instance.ref("USERS");
  Future getSuccessQuotes()async{
    final response =await http.get(Uri.parse("https://officeapi.akashrajpurohit.com/quote/random"));
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){

      _QUOTE = data["quote"];
    setState(() {

    });
    }
  }

  @override
  void initState() {
    getSuccessQuotes();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    return SafeArea(
        child: Scaffold(
          
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
                          child: Icon(Icons.bookmark_added,color: Colors.white,))

                        ),


                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                          onTap: (){
                            showDialog(context: context, builder:  (context) {

                              return AlertDialog(
                                  icon: Icon(Icons.perm_device_info,color: Colors.green,size: 30,),
                                  content: Text("If you notice something Wrong. \nPlease Report us Immediately!\nThanks"),
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
              title: Text("Success" ,style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
            ),
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    child: Container(
                      child: Card(
                        elevation: 30,
                        color: Colors.white,
                        shadowColor: Colors.green,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(child: Text("$_QUOTE",style: TextStyle(fontSize: 25),)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: (){

                         if(_AUTH!=null){

                           Random RD = Random();
                           var RANDS = RD.nextInt(10000000)*10;

                           _DB.child(_AUTH!.uid.toString())
                               .child("Saved")
                               .update({
                             "SAVES$RANDS":_QUOTE,
                           });
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Post Saved!")));
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
                          onTap:(){
                            Clipboard.setData(ClipboardData(text:_QUOTE));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Text Copied")));

                          },
                          child: Icon(Icons.copy,color: Colors.lightBlue,size: 54,)),

                      SizedBox(width: 12,),
                      InkWell(
                          onTap: (){

                            getSuccessQuotes();

                          },
                          child: Icon(Icons.next_plan_sharp,color: Colors.green,size: 55,))
                    ],),


                ],
              ),
            ),
          )

        )

    );
  }
}
