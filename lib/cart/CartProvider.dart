
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foody/cart/cart_bloc.dart';

import 'package:foody/Api/api.dart';

class CartProvider extends InheritedWidget {
  final CartBloc itemBloc;


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static CartBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(CartProvider) as CartProvider)
          .itemBloc;

  CartProvider({Key key, CartBloc itemBloc, Widget child,String apiKey})
      : this.itemBloc = itemBloc ?? CartBloc(Api(),apiKey),

        super(child: child, key: key);

}