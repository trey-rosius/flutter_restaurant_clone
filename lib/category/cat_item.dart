class CategoryItem{
  final int id;
  final String name;
  final String imageUrl;

  CategoryItem({this.id, this.name, this.imageUrl});

  CategoryItem.fromMap(Map<String,dynamic> map)
  :
      id = map['id'],
        name = map['name'],
      imageUrl = map['image'];


}