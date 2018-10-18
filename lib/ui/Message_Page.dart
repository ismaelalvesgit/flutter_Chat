import 'package:chat/helpers/Firestore_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessagePage extends StatefulWidget {

  final String room;

  MessagePage({ Key key ,this.room}) : super (key: key) ;

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {


  final _auth = FirebaseAuth.instance;

  String _user;
  @override
  void initState() {
    super.initState();

    _auth.currentUser().then((user) {
      _user = user.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        top: false,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Chat App"),
            centerTitle: true,
            elevation:
                Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                  child: StreamBuilder(
                      stream: Firestore.instance
                          .collection("chat")
                          .document(
                          "${widget.room}")
                          .collection("messagem")
                          .orderBy("date")
                          .snapshots(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          default:
                            return ListView.builder(
                                reverse: true,
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) {
                                  List r = snapshot.data.documents.reversed.toList();
                                  if (r[index]
                                          .data["email"] !=
                                      _user) {
                                    return ChatMessage1(
                                        r[index].data);
                                  } else {
                                    return ChatMessage2(
                                        r[index].data);
                                  }
                                });
                        }
                      })),
              Divider(
                height: 1.0,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
                child: TextComposer(room: this.widget.room,),
              )
            ],
          ),
        ));
  }
}

class TextComposer extends StatefulWidget {

  final String room;

  TextComposer({Key key, this.room}) : super (key: key);

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  final _firebaseAuth = FirebaseAuth.instance;

  final _msgController = TextEditingController();

  final _menssage = MessageHelpers();

  bool _isComposing = false;

  String _user;

  @override
  void initState() {
    super.initState();

    setState(() {
      _firebaseAuth.currentUser().then((user) {
        _user = user.email;
      });
    });
  }

  void _reset(){
    setState(() {
      _msgController.clear();
      _isComposing = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[200])))
            : null,
        child: Row(
          children: <Widget>[
            Container(
              child:
                  IconButton(icon: Icon(Icons.photo_camera), onPressed: () {}),
            ),
            Expanded(
              child: TextField(
                controller: _msgController,
                decoration:
                    InputDecoration.collapsed(hintText: "Enviar Messagem"),
                onChanged: (text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: (text) {
                  _menssage.sendMessage(
                      msg: _msgController.text,
                      email: _user,
                      dth: DateTime.now(),
                      room:
                          "${widget.room}");
                  _reset();
                },
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoButton(
                        child: Text("Enviar"),
                        onPressed: _isComposing ? () {
                          _menssage.sendMessage(
                              msg: _msgController.text,
                              email: _user,
                              dth: DateTime.now(),
                              room:
                              "${widget.room}");
                          _reset();
                        } : null)
                    : IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _isComposing ? () {
                          _menssage.sendMessage(
                              msg: _msgController.text,
                              email: _user,
                              dth: DateTime.now(),
                              room:
                              "${widget.room}");
                          _reset();
                        } : null)),
          ],
        ),
      ),
    );
  }
}

class ChatMessage1 extends StatelessWidget {
  final Map<String, dynamic> data;

  ChatMessage1(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://s3-us-west-2.amazonaws.com/s.cdpn.io/195612/chat_avatar_03.jpg"),
            ),
          ),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(5.0),
                    bottomRight: Radius.circular(10.0)),
                border: Border.all(width: 5.0, color: Colors.grey[400])),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data["email"],
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: Text(data["message"]),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}

class ChatMessage2 extends StatelessWidget {
  final Map<String, dynamic> data;

  ChatMessage2(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0)),
                  border: Border.all(width: 5.0, color: Colors.blueAccent)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    data["email"],
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5.0),
                    child: Text(
                        data["message"]
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://s3-us-west-2.amazonaws.com/s.cdpn.io/195612/chat_avatar_03.jpg"),
            ),
          ),
        ],
      ),
    );
  }
}
