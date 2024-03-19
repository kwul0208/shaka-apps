import 'package:flutter/material.dart';
import 'package:shaka/features/chats/model/chat_model.dart';

class  ChatState extends ChangeNotifier{
  // init var chat
  String _model = "";
  String get model => _model;
  String _img = "";
  String get img => _img;
  String _model_name = "";
  String get model_name => _model_name;

  initVarChat(String model, String img, String model_name){
    _model = model;
    _img = img;
    _model_name = model_name;notifyListeners();

  }

  List<ChatModel> _chat = [];
  List<ChatModel> get chat => _chat;

  addNewChat(ChatModel cm){
    _chat.add(cm);
    notifyListeners();
  }

  bool _wait_response = false;
  bool get wait_response => _wait_response;
  changeWaitResponse(){
    _wait_response = !_wait_response;
    notifyListeners();
  }

  bool _loadBtn = false;
  bool get lodaBtn => _loadBtn;
  changeLodaBtn(bool val){
    _loadBtn = val;
    notifyListeners();
  }


}