import 'package:coffe_brew_crew/services/auth.dart';
import 'package:coffe_brew_crew/shared/constants.dart';
import 'package:coffe_brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});


  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign Up Brew Crew'),
        actions: [
          FlatButton.icon(
            onPressed: (){
              widget.toggleView();
            },
            icon: Icon(Icons.person),
            label: Text('Sign in'),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        // child: RaisedButton(
        //   child: Text('Sign in anon'),
        //   onPressed: () async {
        //     dynamic result = await _auth.signInAnon();
        //     if(result == null){
        //       print('error sign in ');
        //     }else{
        //       print('sign in ');
        //       print(result.uid);
        //     }

        //   },
        // ),
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                validator: (val) => val.isEmpty? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'password'),
                obscureText: true,
                validator: (val) => val.length < 6? 'Enter a password 6+ char long' : null,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                color: Colors.pink[400],
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  // print(email);
                  // print(password);
                  if(_formkey.currentState.validate()){
                    setState(() {
                      loading = true;
                    });
                    dynamic result = await _auth.registerWithEmailPassword(email,password);
                    if(result == null){
                      setState(() {
                        error = 'please supply a valid email (or) already registered';
                        loading = false;
                      });
                    }
                  }
                },
              ),
              SizedBox(height:12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red,fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}