import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foody/cart/CartProvider.dart';
import 'package:foody/cart/shopping_cart_item.dart';
import 'package:foody/cart/single_shopping_cart_item.dart';


import 'package:shared_preferences/shared_preferences.dart';
class ShoppingCart extends StatefulWidget {

  @override
  _ShoppingCartState createState() => new _ShoppingCartState();
}
int _counter = 0;


class _ShoppingCartState extends State<ShoppingCart> {

  String apiKey;

  _loadApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      apiKey = prefs.getString('api_key');
      print(apiKey);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadApiKey();
    //   fetchShop();

  }




  @override
  Widget build(BuildContext context) {

    final itemBloc = CartProvider.of(context);
    return new Scaffold(
      appBar: new AppBar
        (
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
        automaticallyImplyLeading: false,
       // title: new Text(AppLocalizations.of(context).shoppingCart, style: new TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 26.0)),
        title: new Text("Your Order", style: new TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 26.0)),
        actions: <Widget>
        [
          new Center
            (
            child: new IconButton
              (
              onPressed: () => Navigator.of(context).pop(),
              icon: new Icon(Icons.close, color: Colors.white),
            ),
          )
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new StreamBuilder(
          stream: itemBloc.items,
              builder: ( context, snapshot) {
                return snapshot.hasData ?
                new ListView.builder(


                  itemBuilder: (BuildContext context, int index) =>
                  //  _buildCartItem(context,index,snapshot.data.items[index]),
                  // _build(context,snapshot.data.items, index),
                  new SingleShoppingCartItems(snapshot.data.items,index),





                  itemCount: snapshot.data.items.length,


                )
                    : new Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: new Center(child: new CircularProgressIndicator()
                  ),
                );

              }),

        ],
      ),

      bottomNavigationBar: new Container(
        color: Theme.of(context).primaryColor,

        child:
            new MaterialButton
              (
              onPressed: (){return Navigator.pushNamed(context, "/InvoicingCart");},
              color: Theme.of(context).primaryColor,
              child: new Padding
                (
                padding: const EdgeInsets.all(24.0),
                child: new Text("Proceed to Invoice", style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w600)),
              ),
            ),

        ),


    );

  }
}
