import 'package:chat/helpers/Authenticaion_helpers.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {

  LoginPage({Key key, this.title, this.auth, this.onSignIn}) : super(key: key);

  final String title;
  final BaseAuth auth;
  final VoidCallback onSignIn;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _authHelpers = AuthHelpers();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            "imagens/bg-login.jpg",
            fit: BoxFit.cover,
            height: 1000.0,
          ),
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Icon(Icons.check, size: 140.0, color: Colors.white),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.person_outline,
                          color: Colors.white,
                        ),
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: "You@email.com",
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.white)
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Email invalido!";
                      }
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                        ),
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: "Passoword",
                        labelText: "Senha",
                        labelStyle: TextStyle(color: Colors.white)
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Email invalido!";
                      }
                    },
                  ),
                  Container(
                    height: 50.0,
                    width: 400.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50.0))
                    ),
                    child: RaisedButton(
                      onPressed: (){
                        _authHelpers.signIn(_emailController.text, _passwordController.text).then((any){
                          Navigator.pushReplacementNamed(context, "/users");
                        });

                      },
                      color: Colors.blue,
                      child: Text("Submit", style: TextStyle(color: Colors.white),),
                    ),
                    margin: EdgeInsets.only(top: 50.0),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
