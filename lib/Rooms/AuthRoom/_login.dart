import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quoteapp/Rooms/AuthRoom/_signup.dart';
import 'package:quoteapp/Rooms/Bookmark.dart';

import '../../Menue.dart';
import '../../Toast.dart';
class LOGINROOM extends StatefulWidget {
  const LOGINROOM({super.key});

  @override
  State<LOGINROOM> createState() => _LOGINROOMState();
}

class _LOGINROOMState extends State<LOGINROOM> {
  @override
  TextEditingController _PasswordController = TextEditingController();
  TextEditingController _EmailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _UserAuth = FirebaseAuth.instance;

  void _LoginIn(){
    _UserAuth.signInWithEmailAndPassword(email: _EmailController.text.toString(), password: _PasswordController.text.toString())
        .then((value) => {

      Utils().message("Welcome Back"),
      Navigator.push(context, MaterialPageRoute(builder: (context) => const BookMark(),)),
    }).onError((error, stackTrace) => {
      Utils().message("Incorrect Details!"),


    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
          onWillPop: () async{

            return false;
          },
          child: Scaffold(
            appBar: AppBar(

              leading:InkWell(
                  onTap:(){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Menue(),));
                  },
                  child: Icon(Icons.cancel_outlined,color: Colors.red,size: 40,)),
            ),
            body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [


                                Text("Welcome Back!",style: TextStyle(color: Colors.deepPurple,fontSize: 28,fontWeight: FontWeight.bold),),

                                SizedBox(height:60,),

                                TextFormField(
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'Incorrect Details';
                                    }
                                  },
                                  controller: _EmailController,
                                  decoration: InputDecoration(
                                    label: Text("Email",style: TextStyle(fontSize: 16),),

                                  ),
                                ),
                                SizedBox(height: 14,),
                                TextFormField(
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'Incorrect Details';
                                    }
                                  },
                                  controller: _PasswordController,
                                  decoration: InputDecoration(
                                    label: Text("Password",style: TextStyle(fontSize: 16),),
                                  ),
                                ),
                                SizedBox(height: 14,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Sign In",style: TextStyle(color: Colors.deepPurple,fontSize: 30,fontWeight: FontWeight.bold),),
                                    InkWell(
                                        onTap:(){
                                          if(_formKey.currentState!.validate()){

                                            _LoginIn();
                                          }
                                        },
                                        child: Icon(Icons.arrow_circle_right_rounded,size: 80,color: Colors.deepPurple,))
                                  ],
                                ),

                                SizedBox(height: 25,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                        onTap:(){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SIGNUPROOOM(),));
                                        },
                                        child: Text("Sign Up",style: TextStyle(decoration: TextDecoration.underline,color: Colors.deepPurple,fontSize: 16,fontWeight: FontWeight.bold))),
                                    Text("Forgot Password",style: TextStyle(decoration: TextDecoration.underline,color: Colors.deepPurple,fontSize: 16,fontWeight: FontWeight.bold)),


                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            ),
          ),
        )
    );
  }
}
