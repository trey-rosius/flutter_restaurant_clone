import 'package:foody/category/cat_item.dart';

class CategoryItems {
  final List<CategoryItem> items;


  CategoryItems({this.items});

  CategoryItems.fromMap(Map<String, dynamic> map)
      : items = new List<CategoryItem>.from(map['Categories'].map((item) => new CategoryItem.fromMap(item)));

}