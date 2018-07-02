import 'dart:async';


import 'package:foody/Api/api.dart';
import 'package:foody/category/cat_item_list.dart';
import 'package:foody/items/food_items.dart';
import 'package:rxdart/rxdart.dart';

class FoodItemsBloc{
  Stream<FoodItems> _itemResults = Stream.empty();

  Stream<FoodItems> get itemResults => _itemResults;
  final Api api;


  FoodItemsBloc(this.api)
  {
    _itemResults = api.fetchFoodItems(0).asStream();



        }



}