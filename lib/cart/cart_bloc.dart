import 'dart:async';

import 'package:foody/Api/api.dart';
import 'package:foody/cart/cart_item_count.dart';
import 'package:foody/cart/shopping_cart_items.dart';
import 'package:rxdart/subjects.dart';

class CartBloc{
  final Api api;
  final String apiKey;

  Stream<CartItemCount> _itemCount = Stream.empty();

  Stream<CartItemCount> get itemCount => _itemCount;

  Stream<ShoppingCartItems> _items = Stream.empty();

  Stream<ShoppingCartItems> get items => _items;

  CartBloc(this.api,this.apiKey)
  {

  _itemCount = api.getCartItemCount(apiKey).asStream();
  _items = api.fetchCartItems(apiKey).asStream();


  }



}