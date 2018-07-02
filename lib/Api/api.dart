
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:foody/cart/cart_item_count.dart';
import 'package:foody/cart/response.dart';
import 'package:foody/cart/shopping_cart_items.dart';
import 'package:foody/category/cat_item_list.dart';
import 'package:foody/items/food_item.dart';
import 'package:foody/items/food_items.dart';
import 'package:http/http.dart' as http;

class Api{


 //static final String baseUrl = 'http://192.168.1.100/restaurant/v1/';
  static final String baseUrl = 'http://192.168.43.17/restaurant/v1/';

  Future<CategoryItems> fetchFoodCategories() async {
    final response =
    await http.get(baseUrl + 'food/categories');
    final data = json.decode(response.body);
    print(data);
    return new CategoryItems.fromMap(data);


  }

  Future<FoodItems> fetchFoodItems(int pageNum) async {
    final response =
    await http.get(baseUrl + '/food/items/$pageNum');
    final data = json.decode(response.body);
    print(data);
    return new FoodItems.fromMap(data);


  }

 Future<http.Response> registerUser(String userKey,String name,String email, String userType) async
  {
    var registerUser = baseUrl+"register";

    final response = await http.post(registerUser, body: {"user_key": userKey, "username": name,"email":email,"user_type":userType});

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");


    return response;



  }

  Future<FoodItem> fetchSingleItem(int id,String apiKey) async {

    final response =
    await http.get(baseUrl + 'food/item/$id',headers: {HttpHeaders.CONTENT_TYPE: "application/json",HttpHeaders.AUTHORIZATION:apiKey});

    final responseJson = json.decode(response.body);
    print(responseJson);

    return new FoodItem.fromJson(responseJson);
  }

 Future<Response> addToCart(int itemId, int quantity,String price,String apiKey) async {


    var addToCart = baseUrl+"food/items/$itemId/addToCart";


    var response = await http.post(
        addToCart,
        headers: {
          HttpHeaders.AUTHORIZATION: apiKey
        },
        body: {"quantity": quantity.toString(),"price":price}
    );
   final  data = json.decode(response.body);
    print(data);
    return new Response.fromJson(data);

  }

  Future<CartItemCount> getCartItemCount(String apiKey) async {


    var getItemCount = baseUrl+"food/purchases/count";


    var response = await http.get(
        getItemCount,
        headers: {
          HttpHeaders.AUTHORIZATION: apiKey
        }

    );
    final  data = json.decode(response.body);
    print(data);
    return new CartItemCount.fromJson(data);

  }

 Future<ShoppingCartItems> fetchCartItems(String apiKey) async {

    final response =
    await http.get(baseUrl + 'food/cart',headers: {HttpHeaders.AUTHORIZATION:apiKey});

    final responseJson = json.decode(response.body);
    //   print(responseJson['cart_items']);

    return new ShoppingCartItems.fromMap(responseJson);


  }
}