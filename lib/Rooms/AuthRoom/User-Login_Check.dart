

import 'package:firebase_auth/firebase_auth.dart';

class LoginCheckService{

  void isLogin(){
    final user = FirebaseAuth.instance.currentUser;


    try{
      if(user!=null){

      }

    }catch(value){

    }


  }

}