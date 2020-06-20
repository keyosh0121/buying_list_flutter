import 'package:flutter/material.dart';
import 'package:tokyo_stroll/services/auth.dart';
import 'package:tokyo_stroll/utillities/validator.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black87,elevation:0),
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
                  padding:EdgeInsets.symmetric(horizontal:40,vertical:60),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          Text("New User Registration",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Email"
                            ),
                            validator: (val) => Validator().validateEmail(val),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (val){
                              setState(() => this.email = val);
                            },
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Password",
                              hintText: "Enter at least 6 characters"
                            ),
                            validator: (val) => Validator().validatePassword(val),
                            onChanged: (val){
                              setState(() => this.password = val);
                            },
                          ),
                          SizedBox(height: 20.0),
                          RaisedButton(
                            child: Text("Register new user"),
                            color: Colors.blue,
                            onPressed: () async {
                              if (_formKey.currentState.validate()){
                                dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                                if (result != null) {
                                  Navigator.popAndPushNamed(context, '/');
                                }
                              }
                            },
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