import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shaka/constants/constants.dart';
import 'package:shaka/features/chats/model/chat_model.dart';
import 'package:shaka/features/chats/presentation/pages/chats.dart';
import 'package:shaka/features/chats/provider/chat_state.dart';
import 'package:shaka/features/history/model/chat_history_model.dart';
import 'package:shaka/features/image_generator/presentation/pages/chats.dart';
import 'package:shaka/features/image_generator/provider/chat_state.dart';
import 'package:shaka/local_services/sqlite_service.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<ChatHistoryModel> _chatH = [];
  List<ChatModel> _cD = [];


  @override
  void initState() {
    super.initState();
  }

  Future<void> _displaySecondView(Widget page)async{
    var result =  await Navigator.push(context, MaterialPageRoute(builder: (context)=> page));
    
    if (!mounted) return;
    Timer(Duration(milliseconds: 200), () async {
      await getHistoryChatLocal();
      setState(() {});
    });
    print("refresh");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Chats History"),
        elevation: .3,
      ),
      body: FutureBuilder(
        future: getHistoryChatLocal(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: _chatH.length,
              itemBuilder: (context, i){
                return Slidable(
                  key: ValueKey(i),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    dismissible: DismissiblePane(onDismissed: () {
                      SqliteService.deleteItem(_chatH[i].id);
                    }),
                    children: const [
                      SlidableAction(
                        onPressed: null,
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      String _asset_img  = '';
                      String _model = '';
                      switch (_chatH[i].model_name) {
                        case "GPT 4":
                          _asset_img = 'assets/images/ChatGpt-Logo-black_white.png';
                          _model  = 'gpt-4-turbo-preview';
                          Provider.of<ChatState>(context, listen: false).changeIsFirstChat(false, _chatH[i].id);
                          Provider.of<ChatState>(context, listen: false).initVarChat(_model, _asset_img, _chatH[i].model_name!);
                          _displaySecondView(Chat(chat_id: _chatH[i].id,));
                          break;
                        case 'Image Generator':
                          _asset_img = 'assets/images/Screenshot_2024-02-24_at_20.48.35-removebg-preview.png';
                          _model = 'dall-e-3';
                          Provider.of<ChatStateImage>(context, listen: false).changeIsFirstChat(false, _chatH[i].id);
                          Provider.of<ChatStateImage>(context, listen: false).initVarChat(_model, _asset_img, _chatH[i].model_name!);
                          _displaySecondView(ChatImage(chat_id: _chatH[i].id,));
                          break;
                        default:
                          _asset_img = 'assets/images/ChatGPT-logo-green_white.png';
                          _model = 'gpt-3.5-turbo';
                          Provider.of<ChatState>(context, listen: false).changeIsFirstChat(false, _chatH[i].id);
                          Provider.of<ChatState>(context, listen: false).initVarChat(_model, _asset_img, _chatH[i].model_name!);
                          _displaySecondView(Chat(chat_id: _chatH[i].id,));
                        
                      }
                    },
                    child: ListTile(
                      isThreeLine: true,
                      leading: CircleAvatar(backgroundImage: AssetImage(_chatH[i].img_model!), radius: 16,),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_chatH[i].model_name!, style: TextStyle(fontWeight: FontWeight.w500),),
                          Text(_chatH[i].updated_at.substring(0, 16), style: TextStyle(fontSize: 11, color: lightTextColor),)
                        ],
                      ),
                      subtitle: Text(_chatH[i].first_message),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }

  getHistoryChatLocal() async {  
    _chatH = await SqliteService.getItems();
    for (var e in _chatH) {
      print([e.id, e.first_message, e.img_model, e.model_name, e.local, e.updated_at]);
      // SqliteService.deleteItem(e.id);
    }
    // _cD = await SqliteService.getItemsDetail(31);
    // // _cD = await SqliteService.getItemsAll();
    // for (var e in _cD) {
    //   print([e.chat_id, e.content, e.role]);
    //   // SqliteService.deleteItem(e.id);
    // }
    // SqliteService.printChatTableColumns();
  }



}