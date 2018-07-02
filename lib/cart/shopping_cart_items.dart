import 'package:foody/cart/shopping_cart_item.dart';

class ShoppingCartItems{
  final List<ShoppingCartItem> items;


  ShoppingCartItems({this.items});

  ShoppingCartItems.fromMap(Map<String, dynamic> map)
      : items = new List<ShoppingCartItem>.from(map['cart_items'].map((item) => new ShoppingCartItem.fromMap(item)));

}