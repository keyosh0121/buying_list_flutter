import 'package:flutter/material.dart';
import 'package:tokyo_stroll/utillities/validator.dart';
import 'package:provider/provider.dart';
import 'package:tokyo_stroll/models/user.dart';
import '../services/auth.dart';

class AuthenticatePage extends StatefulWidget {
  @override
  _AuthenticatePageState createState() => _AuthenticatePageState();
}

class _AuthenticatePageState extends State<AuthenticatePage> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  String email = '';
  String password = '';
  String error = '';

  Widget getStatus(){

    final user = Provider.of<User>(context);
    if (!isLoading & (user == null)){
      return Text("LOGIN",style: TextStyle(fontWeight: FontWeight.bold,fontSize:16));
    } else if (isLoading){
      return CircularProgressIndicator(
        semanticsLabel: "a",
      );
    } else {
      return Text("Authenticated!",style:TextStyle(color: Colors.green));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Log in"),
          backgroundColor: Colors.black87
        ),
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: FractionalOffset.topLeft,
                      end: FractionalOffset.bottomRight,
                      colors: [
                        const Color(0xffe4a972).withOpacity(0.8),
                        const Color(0xff9941d8).withOpacity(0.8),
                      ],
                      stops: const [
                        0.0,
                        1.0,
                      ],
                    ),
                  ),
          child: SingleChildScrollView(
            
              child: Column(
              children: <Widget>[
                Container(
                  padding:EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Email",
                            filled: true,
                            fillColor: Colors.white.withOpacity(.1),
                          ),
                          onChanged: (val){
                            setState(() => this.email = val);
                          },
                          validator: (val) => Validator().validateEmail(val),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            filled: true,
                            fillColor: Colors.white.withOpacity(.1),
                          ),
                          onChanged: (val){
                            setState(() => this.password = val);
                          },
                          validator: (val) => Validator().validatePassword(val),
                        ),
                        SizedBox(height: 20.0),
                        Text(error, style: TextStyle(fontSize: 13,color: Colors.red)),
                        RaisedButton(
                          
                          child: Container(padding: EdgeInsets.all(14.0),child: getStatus()),
                          color: Colors.blue,
                          onPressed: () async{
                            if (_formKey.currentState.validate()){
                              try {
                                dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                              } catch(e) {
                                setState(() {
                                  this.error = e.toString();
                                });
                              }
                              
                            }
                            
                          },
                        ),
                        SizedBox(height: 18.0),
                        FlatButton(
                          color: Colors.white.withOpacity(0.3),
                          onPressed: () { Navigator.pushNamed(context,'/register'); }, 
                          child: Text("New to this app? Register now :)",style: TextStyle(fontSize: 12))
                          )
                      ],
                    )
                  )
                )

              ],
            ),
          ),
        ),
    );
  }
}

