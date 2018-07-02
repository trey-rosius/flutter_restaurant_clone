import 'package:flutter/material.dart';
import 'package:foody/category/CategoryItemProvider.dart';
import 'package:foody/category/cat_item.dart';
import 'package:foody/category/cat_item_list.dart';

class CategoryScroller extends StatelessWidget {

     CategoryScroller({Key key});

  _buildCategoryList(BuildContext ctx, int index, List<CategoryItem> categories) {
  //  var actor = actors[index];
    var foodCategory = categories [index];
    print(foodCategory.imageUrl);
    print(foodCategory.name);


    return new GestureDetector(
      onTap: ()=> Navigator.of(ctx).push(
        new MaterialPageRoute(
          builder: (c) {
           // return new QuickChat(actor, avatarTag: index);
          },
        ),
      ),
      child: new Container(

        padding: const EdgeInsets.only(right: 16.0),


        child: new Column(
          children: [

           new Hero(tag: index, child:  new CircleAvatar(
             backgroundColor:Colors.redAccent,
           //  backgroundImage: new AssetImage(actor.avatarUrl),
           //  backgroundImage: new AssetImage(shopCategory["image"]),
             backgroundImage: new NetworkImage(foodCategory.imageUrl),

             radius: 35.0,
           ),),
            new Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: new Text(foodCategory.name,style: new TextStyle(color: Colors.black54,fontSize: 18.0),),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final itemBloc = CategoryItemProvider.of(context);
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        new Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
          child: new Text("Categories", style: const TextStyle(
              color: Colors.redAccent,

              fontSize: 20.0
          )),
        ),

       new Container(
         padding: const EdgeInsets.only(left: 10.0),
         child:  new SizedBox.fromSize(
           size: const Size.fromHeight(120.0),
           child: StreamBuilder(
             stream: itemBloc.results,
             builder: (context, snapshot) {

               if (!snapshot.hasData)
                 return Center(
                   child: CircularProgressIndicator(),
                 );
               CategoryItems item = snapshot.data;
               return ListView.builder(
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