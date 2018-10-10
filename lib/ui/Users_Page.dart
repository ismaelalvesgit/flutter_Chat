import 'package:chat/helpers/Authenticaion_helpers.dart';
import 'package:chat/helpers/Firestore_helpers.dart';
import 'package:chat/ui/Message_Page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  final _authHelpers = AuthHelpers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        centerTitle: true,
        actions: <Widget>[
          GestureDetector(
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.exit_to_app),
            ),
            onTap: (){
              _authHelpers.signOut();
              Navigator.pushReplacementNamed(context, "/");
            },
          )
        ],
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection("users").where("inadmin", isEqualTo: false).where("view", isEqualTo: true).snapshots(),
          builder: (context, snapshot){
            switch ( snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index){
                    return ListUsers(snapshot.data.documents[index].data);
                  },
                );
            }
          }
      )
    );
  }

}

class ListUsers extends StatelessWidget {

  final Map< String, dynamic > data;

  ListUsers(this.data);
  
  final _authHelpers = AuthHelpers();

  final _messageHelpers = MessageHelpers();

  String _room;

  _goToChat(String user2){

   _authHelpers.currentUser().then((user1){
    _room = _messageHelpers.createPairId(user1: user1, user2: user2);
   });
   
  }
  
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Card(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Container(
                  height: 80.0,
                  width: 80.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                          image: NetworkImage(data["photo"]))
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(data["email"]),
                      Text(data["status"])
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      onTap: (){
          _goToChat(data["uid"]);
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> MessagePage(room: _room,)));
      }
    );
  }
}



