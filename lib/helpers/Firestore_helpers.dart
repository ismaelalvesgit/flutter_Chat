import 'package:cloud_firestore/cloud_firestore.dart';

class MessageHelpers{

  final  Firestore _firestore = Firestore.instance;

  createPairId({String user1, String user2}){

    String pairID;

    if(user1.length < user2.length){

      pairID = "$user1$user2";
    }else{
      pairID = "$user2$user1";
    }
    print(pairID);
    return pairID;
  }

  sendMessage({String msg, String email,  DateTime dth, String room}) async{

    await _firestore.collection("chat").document(room).collection("messagem").add({
      "email":email,
      "message": msg,
      "cargo":'developer',
      "date": dth
    });

  }



}