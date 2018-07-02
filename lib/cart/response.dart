class Response{
  final bool error;
  final String messages;

  Response({this.error, this.messages});


  factory Response.fromJson(Map<String, dynamic> json) {
    return new Response(
      error :json['error'],
      messages: json['messages']


    );
  }


}