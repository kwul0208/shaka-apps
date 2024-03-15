class ChatModel{
  final String role;
  final String content;


  ChatModel({required this.role, required this.content,});

  factory ChatModel.fromJson(dynamic json){
    return ChatModel(
      role: json['role'],
      content: json['content'],
    );
  }

  static List<ChatModel> chatModelFromSnapshot(List snapshot){
    return snapshot.map((e){
      return ChatModel.fromJson(e);
    }).toList();
  }
  
}