import 'package:flutter/material.dart';
import 'package:foody/Api/api.dart';

import 'package:foody/items/FoodItemProvider.dart';
import 'package:foody/items/food_item.dart';
import 'package:foody/items/food_items.dart';
import 'package:foody/single_item/SingleItemProvider.dart';
import 'package:foody/single_item/single_item.dart';
import 'package:foody/single_item/single_items_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExtrasScreen extends StatefulWidget {
  ExtrasScreen({Key key});
  @override
  _ExtrasScreenState createState() => new _ExtrasScreenState();
}

class _ExtrasScreenState extends State<ExtrasScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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


  _buildCategoryList(BuildContext ctx, int index, List<FoodItem> items) {
    //  var actor = actors[index];
    var foodItems = items [index];
    print(foodItems.imageUrl);
    print(foodItems.name);


    return  new Card(
      elevation: 5.0,
      shape:  new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)),
      child:
            new GridTile(child: new FadeInImage.assetNetwork(placeholder: 'assets/images/placeholder.jpg', image: foodItems.imageUrl),

        footer: new GridTileBar(
              backgroundColor: Colors.black54,
              title:  new Text(foodItems.name,style: new TextStyle(color: Colors.white,fontSize: 16.0),),
              subtitle:new Text("\$"+foodItems.price.toString(),style: new TextStyle(color: Colors.white,fontSize: 14.0),),
              trailing: new MaterialButton(
                highlightColor: Theme.of(context).accentColor,
                onPressed: () async {


                },
                elevation: 10.0,
                minWidth: 20.0,
                color: Theme.of(context).accentColor,
                child: new Icon(
                    Icons.add_shopping_cart, size: 20.0,
                    color: Colors.white),
              ),
            ),),



    );
  }

  @override
  Widget build(BuildContext context) {

    final itemBloc = FoodItemProvider.of(context);
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          new Container(
            padding: const EdgeInsets.only(left: 10.0,top:30.0,bottom: 10.0),
            child: new Text("Add Extras", style: const TextStyle(
                color: Colors.redAccent,

                fontSize: 20.0
            )),
          ),

          new Container(
            padding: const EdgeInsets.only(left: 10.0),
            child:  new SizedBox.fromSize(
              size: const Size.fromHeight(420.0),
              child: StreamBuilder(
                stream: itemBloc.itemResults,
                builder: (context, snapshot) {

                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  return new GridView.builder(
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    itemCount: 9,
                    scrollDirection: Axis.horizontal,

                    itemBuilder: (context, index)=>_buildCategoryList(context, index, snapshot.data.items)
                  );
                },
              ),
            ),
          )
        ],

    );







  }

}
