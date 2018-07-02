import 'dart:async';


import 'package:foody/Api/api.dart';
import 'package:foody/category/cat_item_list.dart';
import 'package:foody/items/food_items.dart';
import 'package:rxdart/rxdart.dart';

class CategoryItemsBloc{

  final Api api;
  Stream<CategoryItems> _results = Stream.empty();
  Stream<FoodItems> _itemResults = Stream.empty();

  Stream<CategoryItems> get results => _results;
  Stream<FoodItems> get itemResults => _itemResults;


  CategoryItemsBloc(this.api)
  {
    _results = api.fetchFoodCategories().asStream();
  }



}