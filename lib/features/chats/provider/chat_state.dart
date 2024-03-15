import 'package:flutter/material.dart';
import 'package:shaka/features/chats/model/chat_model.dart';

class  ChatState extends ChangeNotifier{
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


}