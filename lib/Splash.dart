import 'dart:async';

import 'package:flutter/material.dart';

import 'Menue.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
@override
  void initState() {
  Timer(Duration(seconds: 5), () {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Menue(),));
  });

  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

           Center(child: Image.asset("assets/images/quote.png",height: 210,width: 210,)),
            SizedBox(height: 10,),
            CircularProgressIndicator(color: Colors.white,strokeWidth: 2),
          ],
        ),
      ),
    );
  }
}
