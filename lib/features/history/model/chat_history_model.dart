class ChatHistoryModel{
  final int id;
  final String ? img_model;
  final String ? model_name;
  final String first_message;
  final String updated_at;
  final String ? local;



  ChatHistoryModel({required this.id, this.img_model, this.model_name, required this.first_message, required this.updated_at, this.local});

  factory ChatHistoryModel.fromJson(dynamic json){
    return ChatHistoryModel(
      id: json['id'],
      img_model: json['img_model'],
      model_name: json['model_name'],
      first_message: json['first_message'],
      updated_at: json['updated_at'],
      local: json['local']
    );
  }
  

  static List<ChatHistoryModel> chatHistoryModelFromSnapshot(List snapshot){
    return snapshot.map((e){
      return ChatHistoryModel.fromJson(e);
    }).toList();
  }
  
  ChatHistoryModel.fromMap(Map<String, dynamic> item): 
    id=item["id"], img_model = item['img_model'], model_name= item['model_name'], first_message= item["first_message"], updated_at= item['updated_at'], local = item['local'];
  

   Map<String, Object> toMap(){
    return {'id':id, 'img_model':img_model!, 'model_name':model_name!, 'first_message': first_message, 'updated_at': updated_at, 'local': local!};
  }
   Map<String, Object> toMapInsert(){
    return {'img_model':img_model!, 'model_name':model_name!, 'first_message': first_message, 'updated_at': updated_at,'local': local!};
  }
}