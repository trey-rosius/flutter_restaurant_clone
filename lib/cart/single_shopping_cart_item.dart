import 'dart:convert';

import "package:flutter/material.dart";
import 'package:foody/cart/shopping_cart_item.dart';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SingleShoppingCartItems extends StatefulWidget {
  SingleShoppingCartItems(this.cartItems,this.index):

      assert(cartItems != null),
      assert(index != null);
  SingleShoppingCartItems.from(SingleShoppingCartItems items):cartItems = items.cartItems, index = items.index;
   final List<ShoppingCartItem> cartItems;
   final int index;


  @override
  _SingleShoppingCartItemsState createState() => new _SingleShoppingCartItemsState();
}

class _SingleShoppingCartItemsState extends State<SingleShoppingCartItems> {
  List<ShoppingCartItem> _items;
  int itemIndex;

  int _counter =1;
  String apiKey;
  int userId;
  _loadApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      apiKey = prefs.getString('apiKey');
      print(apiKey);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _loadApiKey();
    super.initState();
  }
/*
  _delete(int id)
  async {
    var result = await ApiClient.deleteFromCart(id,apiKey);
    Map<dynamic,dynamic> data = json.decode(result.body);
    print(data);
  }

*/


Widget _build(BuildContext context,List<ShoppingCartItem> items, index)
{
  final item = items[index].name;
  return new Dismissible(

    // Each Dismissible must contain a Key. Keys allow Flutter to
    // uniquely identify Widgets.
    key: new Key(item),
    // We also need to provide a function that will tell our app
    // what to do after an item has been swiped away.
    onDismissed: (direction) async {
      /*
      if(index>items.length) {
        var result = await ApiClient.deleteFromCart(items[index].id,apiKey);
        Map<dynamic,dynamic> data = json.decode(result.body);
        print(data);
        setState(() {
          items.removeAt(index);

        });


      }
      _delete(items[index].id);
      Scaffold.of(context).showSnackBar(
          new SnackBar(content: new Text("$item "+AppLocalizations.of(context).removed),backgroundColor: Theme.of(context).accentColor,));
   */
    },
    // Show a red background as the item is swiped away
    background: new Container(color: Theme.of(context).accentColor),
    child: new Container(


      padding: const EdgeInsets.all(5.0),
      child:new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        //  new Divider(color: Theme.of(context).accentColor,),
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new SizedBox(
                child:new FadeInImage.assetNetwork(placeholder: 'assets/placeholder.jpg', image: widget.cartItems[widget.index].imageUrl),
                height: 100.0,

                width: 100.0,
              ),
              new Expanded(child:
              new Container(
                padding: const EdgeInsets.all(10.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(items[index].name,style: new TextStyle(fontSize: 15.0),),

                    new Text( '\$'+items[index].price.toString(),style: new TextStyle(fontSize: 20.0,color: Theme.of(context).primaryColor),),


                    new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Expanded(child: new Row(
                          children: <Widget>[
                            new Container(

                              decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.circular(25.0),

                                  border: new Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 1.0
                                  )
                              ),
                              child:  new IconButton(
                                  icon: new Icon(Icons.remove),
                                  onPressed:() async {
                                    if (items[index].quantity <= 1) {
                                      return null;
                                    }
                                    else {
                                      setState((){
                                        items[index].quantity--;
                                      });
                                      /*
                                      var result = await ApiClient.addToCart(items[index].id,items[index].quantity,items[index].other0,apiKey);
                                      print("the result is "+result.toString());
                                      */

                                    }
                                  }
                              ),
                            ),
                            new Container(
                              padding: const EdgeInsets.all(10.0),

                              child: new Center(
                                  child: new Text(items[index].quantity.toString(),
                                      style: Theme.of(context).textTheme.subhead,
                                      textAlign: TextAlign.center)),

                            ),
                            new Container(
                              decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.circular(25.0),

                                  border: new Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 1.0
                                  )
                              ),
                              child: new IconButton(
                                icon: new Icon(Icons.add),
                                onPressed: () async {
                                  setState(() {


                                    items[index].quantity++;


                                  });
                                  /*
                                  var result = await ApiClient.addToCart(items[index].id,items[index].quantity,items[index].other0,apiKey);
                                  print("the result is "+result.toString());
                                  */

                                },
                              ),
                            ),
                          ],
                        ) ),

                      ],
                    ),
                  ],
                ),
              )
              )

              //  new Text(items['description']),

            ],
          )
        ],
      ),



    ),
  );
}


  @override
  Widget build(BuildContext context) {

    return _build(context,widget.cartItems,widget.index);
  //  return _build(context,_items);

  }
}
