import 'package:flutter/material.dart';
import 'package:foody/Api/api.dart';

import 'package:foody/items/FoodItemProvider.dart';
import 'package:foody/items/food_item.dart';
import 'package:foody/items/food_items.dart';
import 'package:foody/single_item/SingleItemProvider.dart';
import 'package:foody/single_item/single_item.dart';
import 'package:foody/single_item/single_items_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodayMenu extends StatefulWidget {
  TodayMenu({Key key});
  @override
  _TodayMenuState createState() => new _TodayMenuState();
}

class _TodayMenuState extends State<TodayMenu> {

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
      child:  new Container(


        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            new Hero(

                tag: foodItems.imageUrl,
                child: new InkWell(
                  onTap:()=>Navigator.of(ctx).push(
                    new MaterialPageRoute(
                      builder: (context)
                      =>  new SingleItemProvider(
                        itemBloc: new SingleItemsBloc(new Api(),foodItems.id,apiKey),
                        child: new SingleItem(foodItems.name,foodItems.id,foodItems.imageUrl,foodItems.name,foodItems.price),
                      )
                    ),
                  ) ,
                  child:   AspectRatio(

                    aspectRatio: 18.0 / 11.0,
                    child: new FadeInImage.assetNetwork(placeholder: 'assets/images/placeholder.jpg', image: foodItems.imageUrl),),
                )
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 8.0,left: 10.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(foodItems.name,style: new TextStyle(color: Colors.black54,fontSize: 16.0),),
                  new Text("\$"+foodItems.price.toString(),style: new TextStyle(color: Colors.red,fontSize: 14.0),),


                ],
              ),
            ),

          ],
        ),
      ),

    );
  }

  @override
  Widget build(BuildContext context) {

    final itemBloc = FoodItemProvider.of(context);
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        new Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
          child: new Text("Today's Menu", style: const TextStyle(
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
                FoodItems item = snapshot.data;
                return new GridView.builder(
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2 ),
                  itemCount: item.items.length,
                  scrollDirection: Axis.horizontal,

                  itemBuilder: (context, index) =>  _buildCategoryList(context, index, item.items),
                );
              },
            ),
          ),
        )
      ],
    );







  }

}
