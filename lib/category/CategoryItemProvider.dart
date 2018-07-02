
import 'package:flutter/material.dart';
import 'package:foody/category/category_items_bloc.dart';
import 'package:foody/Api/api.dart';

class CategoryItemProvider extends InheritedWidget {
  final CategoryItemsBloc itemBloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static CategoryItemsBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(CategoryItemProvider) as CategoryItemProvider)
          .itemBloc;

  CategoryItemProvider({Key key, CategoryItemsBloc itemBloc, Widget child})
      : this.itemBloc = itemBloc ?? CategoryItemsBloc(Api()),
        super(child: child, key: key);

}