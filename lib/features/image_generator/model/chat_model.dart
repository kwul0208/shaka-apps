class ChatModelImage{
  final String role;
  final String revised_prompt;
  final String ? url;


  ChatModelImage({required this.role, required this.revised_prompt, this.url});

  factory ChatModelImage.fromJson(dynamic json){
    return ChatModelImage(
      role: json['role'],
      revised_prompt: json['revised_prompt'],
      url: json['url'],
    );
  }

  static List<ChatModelImage> chatModelImageFromSnapshot(List snapshot){
    return snapshot.map((e){
      return ChatModelImage.fromJson(e);
    }).toList();
  }
  
}