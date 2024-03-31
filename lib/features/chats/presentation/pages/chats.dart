import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shaka/constants/constants.dart';
import 'package:shaka/constants/responsive.dart';
import 'package:shaka/features/chats/model/chat_model.dart';
import 'package:shaka/features/chats/model/data_example.dart';
import 'package:shaka/features/chats/provider/chat_state.dart';
import 'package:shaka/features/chats/service/chat_api_service.dart';
import 'package:shaka/global_widgets/alert_widget.dart';
import 'package:shaka/local_services/sqlite_service.dart';

class Chat extends StatefulWidget {
  Chat({super.key, this.chat_id});
  final int? chat_id;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool isAnimating = true;

  List<ChatModel> chats = [];

  ScrollController scrollController = ScrollController();
  ScrollController scrollControllerChat = ScrollController();

  @override
  void initState() {
    super.initState();
    if(widget.chat_id != null) getDetailChat(widget.chat_id);
  }

  @override
  Widget build(BuildContext context) {
    var dataState = Provider.of<ChatState>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset("assets/images/ChatGPT-logo-green_white.png", width: 20,),
            CircleAvatar(backgroundImage: AssetImage(dataState.img), radius: 12,),
            SizedBox(width: 6,),
            Text(dataState.model_name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
          ],
        ),
        actions: [
          SizedBox(width: 26,)
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Expanded(child: Text("data")),
          Expanded(
            child: Consumer<ChatState>(
              builder: (context, data, _) {
                if(data.chat.length == 0){
                  return Padding(
                    padding: const EdgeInsets.all(appPadding * 2),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(backgroundImage: AssetImage(dataState.img), radius: 20,),
                          SizedBox(height: appPadding,),
                          Text(dataState.model_name, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                          SizedBox(height: appPadding,),
                          Text("Discover the revolutionary power of Open AI ${dataState.model_name}, a platform that enables natural language conversations with advanced artificial intelligence. Engage in dialogue, ask questions, and receive intelligent responses to enhance your interactive communication experience.", style: TextStyle(color: lightTextColor), textAlign: TextAlign.center,),
                          SizedBox(height: 20,),
                          InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            onTap: (){
                                  BuildContext scaffoldContext = Scaffold.of(context).context; // Simpan BuildContext yang valid
                              showModalBottomSheet<void>(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                ),
                                context: scaffoldContext,
                                isScrollControlled: true, // set this to true
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState ) {
                                      return Material(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(appPadding),
                                        child: DraggableScrollableSheet(
                                          initialChildSize: 0.8,
                                          minChildSize: 0.25,
                                          maxChildSize: 0.97,
                                          expand: false,
                                          builder: (context, scrollController) {
                                            return Column(
                                              children: <Widget>[
                                                Container(
                                                  // color: Colors.white,
                                                  width: Responsive.screen_width(context),
                                                  height: 80,
                                                  child: ListView(
                                                    controller: scrollController,
                                                    children: <Widget>[
                                                      Align(
                                                        alignment: Alignment.topCenter,
                                                        child: Container(
                                                          height: 5.0,
                                                          width: 70.0,
                                                          decoration: BoxDecoration(
                                                            color: Colors.grey[400],
                                                            borderRadius: BorderRadius.circular(10.0),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 16),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 24),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text('Examples', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: ListView.builder(
                                                    itemCount: data_example.length,
                                                    itemBuilder: (context, index) => Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: appPadding, vertical: appPadding/2),
                                                      child: Material(
                                                        color: bgColor,
                                                        borderRadius: BorderRadius.circular(appPadding),
                                                        child: InkWell(
                                                        borderRadius: BorderRadius.circular(appPadding),
                                                          onTap: (){
                                                            Provider.of<ChatState>(scaffoldContext, listen: false).addNewChat(ChatModel(role: "user", content: data_example[index]['value']));
                                                            ChatApiService.postChat(scaffoldContext, data.model, [{"role": "user", "content": data_example[index]['value']}], data.img, data.model_name, data_example[index]['value']);
                                                            Provider.of<ChatState>(scaffoldContext, listen: false).changeWaitResponse();
                                                            Provider.of<ChatState>(scaffoldContext, listen: false).changeLodaBtn(true);
                                                            Navigator.pop(context);
                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(appPadding),
                                                            child: Column(
                                                              children: [
                                                                Text(data_example[index]['title'], style: TextStyle(fontWeight: FontWeight.w500,  fontSize: 18),),
                                                                Text(data_example[index]['subtitle'], style: TextStyle(color: lightTextColor,  fontSize: 14),)
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      );
                                    
                                    }
                                  );
                                },
                              );
                            },
                            child :Container(
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(6)),
                                border: Border.all(color: lightTextColor)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  children: [
                                    Icon(Icons.wb_incandescent_sharp, size: 18, ),
                                    SizedBox(width: 4,),
                                    Text("Examples", style: TextStyle(fontWeight: FontWeight.w500),),
                                  ],
                                ),
                              ),
                            )
                          )
                        ],
                      ),
                    ),
                  );
                }else{
                  return Padding(
                    padding: const EdgeInsets.all(appPadding),
                    child: ListView.builder(
                      controller: scrollControllerChat,
                      itemCount: data.wait_response == false ? data.chat.length : data.chat.length + 1,
                      itemBuilder: (context, i) {
                        if (i >= data.chat.length) {
                          // Menampilkan pesan "Waiting for the answer" sebagai loading
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0.0), // Atur jarak antara item
                            // minVerticalPadding: -10,
                            isThreeLine: true,
                            dense: true,
                            leading: CircleAvatar(backgroundImage: AssetImage(data.img), radius: 14,),
                            title: Text("ChatGPT", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            subtitle: Align(
                              alignment: Alignment.centerLeft, // Posisikan teks animasi di kiri
                              child: DefaultTextStyle(
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: lightTextColor
                                ),
                                child: AnimatedTextKit(
                                  animatedTexts: [
                                    WavyAnimatedText('Waiting for the answer...', speed: Duration(milliseconds: 100)),
                                  ],
                                  isRepeatingAnimation: true,
                                  repeatForever: true,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0.0), // Atur jarak antara item
                            isThreeLine: true,
                            dense: true,
                            leading: data.chat[i].role == "user" ? Icon(Icons.person) : CircleAvatar(backgroundImage: AssetImage(dataState.img), radius: 14,),
                            title: data.chat[i].role == "user" ? Text("You", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),) : Text(dataState.model_name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            subtitle: data.chat[i].role == "user"
                                ? Text(data.chat[i].content, style: TextStyle(fontSize: 14),)
                                : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AnimatedTextKit(
                                        animatedTexts: [
                                          TypewriterAnimatedText(
                                            data.chat[i].content,
                                            textStyle: TextStyle(fontSize: 14.0),
                                            textAlign: TextAlign.start,
                                            speed: widget.chat_id == null ? Duration(milliseconds: 10) : Duration.zero, //history condition
                                          ),
                                        ],
                                        totalRepeatCount: 1,
                                        onFinished: (){
                                          Provider.of<ChatState>(context, listen: false).changeLodaBtn(false);
                                        },
                                    
                                      ),
                                      if(data.chat[i].role == 'assistant')
                                      Builder(
                                        builder: (context) {
                                          if(i != data.chat.length - 1){
                                            return TextButton.icon(
                                              onPressed: (){
                                                Clipboard.setData(ClipboardData(text: data.chat[i].content));
                                                alert(context, "Copied!");
                                              }, 
                                              icon: Icon(Icons.copy, color: Colors.black, size: 16,),
                                              label: Text("Copy", style: TextStyle(color: Colors.black, fontSize: 11)),
                                            );
                                          }else{
                                            if (!data.lodaBtn) {
                                              // return SizedBox();
                                              return TextButton.icon(
                                                onPressed: (){
                                                  Clipboard.setData(ClipboardData(text: data.chat[i].content));
                                                  alert(context, "Copied!");
                                                }, 
                                                icon: Icon(Icons.copy, color: Colors.black, size: 16,),
                                                label: Text("Copy", style: TextStyle(color: Colors.black, fontSize: 11)),
                                              );
                                            }else{
                                              return SizedBox();
                                            }
                                          }
                                        }
                                      )
                                  ],
                                ),
                          );
                        }
                      },
                    ),
                  );
                }
              }
            ),
          ),
          _MessageBar(scrollControllerChat: scrollControllerChat, dataState: dataState,),
        ],
      ),
    );
  } 

  Future<void> getDetailChat(chat_id)async{
    chats = await SqliteService.getItemsDetail(chat_id);
    for (var e in chats) {
      print([e.created_at, e.content]);
    }
    Provider.of<ChatState>(context, listen: false).initChat(chats);
  }                                    
}

class _MessageBar extends StatefulWidget {
  _MessageBar({
    Key? key,
    required this.scrollControllerChat,
    required this.dataState
  }) : super(key: key);
  ScrollController scrollControllerChat;
  ChatState dataState;

  @override
  State<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<_MessageBar> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: appPadding, right: appPadding, bottom: appPadding),
      child: Material(
        borderRadius: BorderRadius.circular(appPadding),
        color: Color.fromARGB(255, 248, 247, 247),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Scrollbar(
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      minLines: 1,
                      autofocus: false,
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                      
                    ),
                  ),
                ),
                Consumer<ChatState>(
                  builder: (context, data, _) {
                    if (data.lodaBtn) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(appPadding),
                        onTap: null,
                        // onTap: () {
                        //   Provider.of<ChatState>(context, listen: false).changeLodaBtn(false);
                        // },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(Icons.send, color: lightTextColor,),
                        ),
                      );
                    }else{
                      return InkWell(
                        borderRadius: BorderRadius.circular(appPadding),
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          Provider.of<ChatState>(context, listen: false).addNewChat(ChatModel(role: "user", content: _textController.text));
                          Provider.of<ChatState>(context, listen: false).changeWaitResponse();
                          Provider.of<ChatState>(context, listen: false).changeLodaBtn(true);
                      
                          List<ChatModel> dataChat = Provider.of<ChatState>(context, listen: false).chat;
                          
                          List<Map<String, dynamic>> dataChatMap = dataChat.map((chat) {
                            return {
                              'role': chat.role,
                              'content': chat.content,
                            };
                          }).toList();
                          
                          ChatApiService.postChat(context, widget.dataState.model, dataChatMap, data.img, data.model_name, _textController.text);
                          _textController.clear();

                      
                          widget.scrollControllerChat.animateTo(
                            widget.scrollControllerChat.position.maxScrollExtent,
                            duration: Duration(milliseconds: 30),
                            curve: Curves.easeOut,
                          );
                      
                      
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(Icons.send),
                        ),
                      );
                    }
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}