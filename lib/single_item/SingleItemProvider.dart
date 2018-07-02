
import 'package:flutter/material.dart';
import 'package:foody/category/category_items_bloc.dart';
import 'package:foody/Api/api.dart';
import 'package:foody/items/food_items_bloc.dart';
import 'package:foody/single_item/single_items_bloc.dart';

class SingleItemProvider extends InheritedWidget {
  final SingleItemsBloc itemBloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static SingleItemsBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(SingleItemProvider) as SingleItemProvider)
          .itemBloc;

  SingleItemProvider({Key key, SingleItemsBloc itemBloc, Widget child,int id,String apiKey})
      : this.itemBloc = itemBloc ?? SingleItemsBloc(Api(),id,apiKey),
        super(child: child, key: key);

}