import 'package:flutter/material.dart';
import 'package:quoteapp/Menue.dart';
import 'package:quoteapp/Rooms/AuthRoom/_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../Toast.dart';
import '../Bookmark.dart';
class SIGNUPROOOM extends StatefulWidget {
  const SIGNUPROOOM({super.key});

  @override
  State<SIGNUPROOOM> createState() => _SIGNUPROOOMState();
}

class _SIGNUPROOOMState extends State<SIGNUPROOOM> {

    TextEditingController _NameController = TextEditingController();
    TextEditingController _PasswordController = TextEditingController();
    TextEditingController _EmailController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    final _UserAuth = FirebaseAuth.instance;
    final _firebaseDatabase = FirebaseDatabase.instance.ref("USERS");



    // Signup the user

    void _signUp() {
      _UserAuth.createUserWithEmailAndPassword(email: _EmailController.text.toString(), password: _PasswordController.text.toString())
          .then((value) => {
            _firebaseDatabase.child(_UserAuth.currentUser!.uid.toString())
            .set({
              "Name" : _NameController.text.toString(),
              "Password" : _PasswordController.text.toString(),
              "Email" : _EmailController.text.toString(),

            }).then((value) => {

              setState(() {

              }),
              Utils().message("Thanks For Joining :)"),
              Navigator.push(context, MaterialPageRoute(builder: (context) => BookMark(),)),
            })
        .onError((error, stackTrace) => {
              Utils().message("Try Again later :("),
            })

      });
    }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
          onWillPop: ()async{
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
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Embrace the Future \nSign Up and Stay Ahead!",style: TextStyle(color: Colors.deepPurple,fontSize: 28,fontWeight: FontWeight.bold),),

                        SizedBox(height: 14,),
                        TextFormField(
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if(value!.isEmpty){
                              return "Incorrect Details";
                            }
                          },
                          controller: _NameController,
                          decoration: InputDecoration(
                            label: Text("Name",style: TextStyle(fontSize: 16),),
                          ),
                        ),
                        SizedBox(height: 14,),
                        TextFormField(
                          controller: _EmailController,
                          validator: (value) {
                            if(value!.isEmpty){
                              return "Incorrect Details";
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            label: Text("Email",style: TextStyle(fontSize: 16),),

                          ),
                        ),
                        SizedBox(height: 14,),
                        TextFormField(
                          controller: _PasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value){
                            if (value!.isEmpty){
                              return "Incorrect Details";
                            }
                          },
                          decoration: InputDecoration(
                            label: Text("Password",style: TextStyle(fontSize: 16),),
                          ),
                        ),
                        SizedBox(height: 14,),
                         Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Sign Up",style: TextStyle(color: Colors.deepPurple,fontSize: 30,fontWeight: FontWeight.bold),),
                            InkWell(
                                onTap: (){

                                  if(_formKey.currentState!.validate()){
                                    _signUp();

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
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LOGINROOM(),));
                                },
                                child: Text("Sign In",style: TextStyle(decoration: TextDecoration.underline,color: Colors.deepPurple,fontSize: 16,fontWeight: FontWeight.bold))),
                            Text("Forgot Password",style: TextStyle(decoration: TextDecoration.underline,color: Colors.deepPurple,fontSize: 16,fontWeight: FontWeight.bold)),


                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }
}
