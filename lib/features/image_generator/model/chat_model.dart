class ChatModelImage{
  final int? chat_id;
  final String role;
  final String revised_prompt;
  final String ? url;
  final String? local;
  final String? created_at;




  ChatModelImage({this.chat_id ,required this.role, required this.revised_prompt, this.url, this.local, this.created_at});

  factory ChatModelImage.fromJson(dynamic json){
    return ChatModelImage(
      chat_id: json['chat_id'],
      role: json['role'],
      revised_prompt: json['revised_prompt'],
      url: json['url'],
      local: json['local'],
      created_at: json['created_at']
    );
  }

  static List<ChatModelImage> chatModelImageFromSnapshot(List snapshot){
    return snapshot.map((e){
      return ChatModelImage.fromJson(e);
    }).toList();
  }

  ChatModelImage.fromMap(Map<String, dynamic> item): 
    chat_id=item["chat_id"], role = item['role'], revised_prompt= item['content'], url= item['image_url'], local= item['local'], created_at = item['created_at'];

    Map<String, Object> toMapInsert(){
    return {'chat_id':chat_id!, 'role':role, 'content':revised_prompt, 'image_url': url!, 'local': local!, 'created_at': created_at!};
    }
  
}