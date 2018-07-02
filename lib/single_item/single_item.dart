import 'package:flutter/material.dart';
import 'package:foody/Api/api.dart';

import 'package:foody/extras/extras_screen.dart';

import 'package:foody/items/FoodItemProvider.dart';
import 'package:foody/items/food_item.dart';
import 'package:foody/items/food_items.dart';
import 'package:foody/items/food_items_bloc.dart';
import 'package:foody/single_item/SingleItemProvider.dart';
import 'package:foody/single_item/single_items_bloc.dart';
import 'package:foody/utils/cart_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingleItem extends StatefulWidget {
  SingleItem(this.title,this.tag,this.imageUrl,this.name,this.price,{Key key});
  final String title;
  final int tag;
  final String imageUrl;
  final String name;
  final int price;

  @override
  _SingleItemState createState() => new _SingleItemState();
}

class _SingleItemState extends State<SingleItem> {

 bool _loaded = false;
 String apiKey;
 _loadApiKey() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   setState(() {
     apiKey = prefs.getString('api_key');
     print(apiKey);
   });
 }
 @override
 initState()
 {
   super.initState();
   _loadApiKey();

 }



 @override
  Widget build(BuildContext context) {

    final itemBloc = SingleItemProvider.of(context);


    return new Scaffold(
        appBar: new AppBar
          (
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: new Text(widget.name, style: new TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 26.0)),
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

        body: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              StreamBuilder(
                stream: itemBloc.itemResults,
                builder: (context, snapshot) {

                  if (snapshot.hasData) {

                    FoodItem item = snapshot.data;
                    return  new Container(


                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            AspectRatio(
                              aspectRatio: 18.0 / 11.0,
                              child: new FadeInImage.assetNetwork(placeholder: 'assets/images/placeholder.jpg', image: item.imageUrl),),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0,left: 10.0),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text(item.name,style: new TextStyle(color: Colors.black54,fontSize: 24.0),),
                                  new Text("\$"+item.price.toString(),style: new TextStyle(color: Colors.red,fontSize: 20.0),),


                                ],
                              ),
                            ),

                          ],
                        ),
                    );
                    //   _buildSingleItem(context, snapshot.data);
                  }
                  else if(snapshot.data == null)
                  {

                    new CircularProgressIndicator();
                  }
                  return new Card(
                    elevation: 5.0,
                    shape:  new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
                    child:  new Container(


                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          new Hero(
                            tag: widget.imageUrl,
                            child: AspectRatio(
                              aspectRatio: 18.0 / 11.0,
                              child: new FadeInImage.assetNetwork(placeholder: 'assets/images/placeholder.jpg', image: widget.imageUrl),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0,left: 10.0),
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(widget.name,style: new TextStyle(color: Colors.black54,fontSize: 24.0),),
                                new Text("\$"+widget.price.toString(),style: new TextStyle(color: Colors.red,fontSize: 20.0),),


                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  );

                },

              ),

              new FoodItemProvider(
                itemBloc: new FoodItemsBloc(new Api()),
                child: new ExtrasScreen(),
              ),
            ],
          ),
        ),
      bottomNavigationBar: new Container(
        color: Theme.of(context).primaryColor,

        child: new Row(
          children: <Widget>[
           new Expanded(child:
           new MaterialButton
             (
             onPressed: (){//return Navigator.pushNamed(context, "/InvoicingCart");
               itemBloc.cartAddition.add(new CartAddition(widget.tag,1,widget.price.toString(),apiKey));
             },
             color: Theme.of(context).primaryColor,
             child: new Padding
               (
               padding: const EdgeInsets.all(24.0),
               child: new Text("Add To Cart", style: new TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.w600)),
             ),
           ),),
           new Container(
             padding: new EdgeInsets.all(5.0),
             child: new CartButton(
               itemCount: 3,
               onPressed: () {
                 //Navigator.of(context).pushNamed(BlocCartPage.routeName);
               },
             ),
           )
          ],
        )


      ),



    );








  }


}

