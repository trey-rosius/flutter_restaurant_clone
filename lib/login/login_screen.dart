import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:foody/cart/CartProvider.dart';
import 'package:foody/cart/cart_bloc.dart';
import 'package:foody/login/Home.dart';
import 'package:foody/registration/registration_provider.dart';
import 'package:foody/registration/register.dart';
import 'package:foody/registration/register_bloc.dart';
import 'package:foody/registration/registration_provider.dart';
import 'package:foody/utils/authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:foody/Api/api.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {





  GoogleSignInAccount _userCurrent;
  BuildContext context;


  bool loading = false;

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController scrollController = new ScrollController();
  String email;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String fcmKey;
  String apiKey;

  onPressed(String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value),backgroundColor: Theme.of(context).accentColor,));
  }


  _saveEmail(String _email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('email', _email);



  }
  _saveApiKey(String apiKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('api_key', apiKey);



  }



  @override
  void dispose() {

    super.dispose();
  }

  @override
  void initState() {

    super.initState();

  }




  Future<Null> _handleSignIn(BuildContext context) async {

    setState(() {
      loading = true;
    });

    FirebaseUser user = await signInWithGoogle();
    if(user != null) {

      print(user.email);
      print(user.uid);
      print(user.displayName);

   //   Register register = new Register(user.uid,user.displayName,user.email,'customer');

     var response = await new Api().registerUser(user.uid, user.displayName, user.email, 'customer');
      Map<String,dynamic> data = json.decode(response.body);

           if(data['error'] == false)
             {
               _saveApiKey(data['api_key']);

               Navigator.of(context).push(
                 new MaterialPageRoute(
                     builder: (context)
                     =>  new CartProvider(
                       itemBloc: new CartBloc(Api(),data['api_key']),
                       child: new Home(),
                     )
                 ),
               );
             //  Navigator.of(context).pushNamed('/Home');
               setState(() {
                 loading = false;
               });
             }
             else
               {
                 setState(() {
                   loading = false;
                 });
                 print('An error occured');
               }


      _saveEmail(user.email);

    //  RegistrationProvider.of(context).regist.add(register);
     // cartBloc.cartAddition.add(CartAddition(product));
     // RegistrationProvider.of(context).regist.add(register);

    }
    else {

      print(user.email);
      print(user.uid);
      print(user.displayName);
      _saveEmail(user.email);

    }

  }




  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;

    final Size screenSize = MediaQuery.of(context).size;
    //print(context.widget.toString());


    return new RegistrationProvider(
      itemBloc: new RegisterBloc(new Api()),
       child: new Scaffold(

           key: _scaffoldKey,
           body: new SingleChildScrollView(
             // controller: scrollController,
               child:new Container(
                 padding: new EdgeInsets.all(10.0),

                 decoration: new BoxDecoration(color: Colors.white),
                 child: new Column(
                   children: <Widget>[

                     new Container(
                       height: screenSize.height / 2,
                       child: new Column(
                         crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           new Center(
                               child: new Image(
                                 image: new ExactAssetImage('assets/images/logo-red.png'),
                                 width: (screenSize.width < 500)
                                     ? 140.0
                                     : (screenSize.width / 3) + 12.0,
                                 height: screenSize.height / 3.5 + 10,
                               )),
                           new Text(
                               "foody",
                               style: const TextStyle(
                                   color: Colors.redAccent,
                                   fontFamily: 'christmas-cookies',
                                   fontWeight: FontWeight.w600,
                                   fontSize: 60.0
                               )
                           ),

                         ],
                       ),
                     ),

                     new Container(
                         height: screenSize.height/2.5,


                         child: new Center(

                           child:   loading == false ?
                           new RaisedButton(onPressed: (){
                             // Navigator.of(context).pushNamed('/PageTwo');
                             _handleSignIn(context);
                           },
                             elevation: 5.0,color: Colors.redAccent,padding: const EdgeInsets.all(20.0),
                             shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                             child: new Text('Google Sign In',style: new TextStyle(color: Colors.white,fontSize: 30.0,),),)
                               :
                               new CircularProgressIndicator()


                         )
                     ),

                     new Container(


                         child: new Center(

                             child: new Text("Terms And Conditions",style: new TextStyle(fontSize: 20.0,color: Colors.black54,fontFamily: 'christmas-cookies',
                               fontWeight: FontWeight.w600,),)  )
                     ),
                   ],
                 ),

               ))),
    );
  }
}
