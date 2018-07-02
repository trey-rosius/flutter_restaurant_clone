import 'dart:async';


import 'package:foody/Api/api.dart';
import 'package:foody/items/food_item.dart';

import 'package:foody/items/food_items.dart';
import 'package:rxdart/rxdart.dart';

class CartAddition
{
  final int id;
  final int quantity;
  final String price;
  final String apiKey;


  CartAddition(this.id, this.quantity, this.price, this.apiKey);

}
class SingleItemsBloc{

  final Api api;

  final StreamController<CartAddition> _cartAdditionController =
  StreamController<CartAddition>();
  Stream<FoodItem> _itemResults = Stream.empty();

  Stream<FoodItem> get itemResults => _itemResults;

  Sink<CartAddition> get cartAddition => _cartAdditionController.sink;
  void dispose() {

    _cartAdditionController.close();
  }


  SingleItemsBloc(this.api,id,apiKey) {
    _itemResults = api.fetchSingleItem(id, apiKey).asStream();
    _cartAdditionController.stream.listen((addition) {
      api.addToCart(
          addition.id, addition.quantity, addition.price, addition.apiKey);
    });
  }

}