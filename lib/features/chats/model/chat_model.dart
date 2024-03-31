class ChatModel{
  final int? chat_id;
  final String role;
  final String content;
  final String? local;
  final String? created_at;


  ChatModel({this.chat_id ,required this.role, required this.content, this.local, this.created_at});

  factory ChatModel.fromJson(dynamic json){
    return ChatModel(
      chat_id: json['chat_id'],
      role: json['role'],
      content: json['content'],
      local: json['local'],
      created_at: json['created_at']
    );
  }

  static List<ChatModel> chatModelFromSnapshot(List snapshot){
    return snapshot.map((e){
      return ChatModel.fromJson(e);
    }).toList();
  }

    ChatModel.fromMap(Map<String, dynamic> item): 
    chat_id=item["chat_id"], role = item['role'], content= item['content'], local= item['local'], created_at = item['created_at'];

    Map<String, Object> toMapInsert(){
    return {'chat_id':chat_id!, 'role':role, 'content':content, 'local': local!, 'created_at': created_at!};
  }
  
}