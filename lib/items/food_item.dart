class FoodItem{

  final int id;
  final int category;
  final int price;
  final String name;
  final String imageUrl;

  FoodItem({this.id, this.category, this.price, this.name, this.imageUrl});

  FoodItem.fromMap(Map<String,dynamic> map)
  :
      id = map['id'],
      category = map['category'],
      price = map['price'],
      name = map['name'],
      imageUrl = map['image_url'];



  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return new FoodItem(
      id :json['id'],
      category: json['category'],
      price:json['price'],
      name : json['name'],
      imageUrl : json['image_url'],

    );
  }


}