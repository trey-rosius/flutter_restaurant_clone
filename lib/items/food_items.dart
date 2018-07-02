
import 'package:foody/items/food_item.dart';

class FoodItems {
  final List<FoodItem> items;


  FoodItems({this.items});

  FoodItems.fromMap(Map<String, dynamic> map)
      : items = new List<FoodItem>.from(map['items'].map((item) => new FoodItem.fromMap(item)));

}