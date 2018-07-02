class CartItemCount{
final bool error;
final int total;

CartItemCount({this.error, this.total});

factory CartItemCount.fromJson(Map<String, dynamic> json) {
  return new CartItemCount(
      error :json['error'],
      total: json['total']


  );
}


}