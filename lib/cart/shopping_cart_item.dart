class ShoppingCartItem{
  final int id;
  final int category;
 int _quantity;
  final String name;
  final int price;
  final String imageUrl;

  int get quantity => _quantity;

  set quantity(int value) {
    _quantity = value;
  }



  ShoppingCartItem.fromMap(Map<String,dynamic> map)
      :
        id = map['id'],
        category = map['category'],
        _quantity = map['quantity'],
        price = map['price'],
        name = map['name'],
        imageUrl = map['image_url'];



}