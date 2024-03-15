import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shaka/constants/constants.dart';
import 'package:shaka/constants/responsive.dart';
import 'package:shaka/features/chats/model/chat_model.dart';
import 'package:shaka/features/chats/provider/chat_state.dart';
import 'package:shaka/features/chats/service/chat_api_service.dart';

class Chat extends StatelessWidget {
  Chat({super.key});

  ScrollController scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset("assets/images/ChatGPT-logo-green_white.png", width: 20,),
            CircleAvatar(backgroundImage: AssetImage("assets/images/ChatGPT-logo-green_white.png"), radius: 12,),
            SizedBox(width: 6,),
            Text("ChatGPT", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
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
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(appPadding * 2),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(backgroundImage: AssetImage("assets/images/ChatGPT-logo-green_white.png"), radius: 20,),
                            SizedBox(height: appPadding,),
                            Text("ChatGPT", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                            SizedBox(height: appPadding,),
                            Text("Discover the revolutionary power of Open AI Gpt 3.5, a platform that enables natural language conversations with advanced artificial intelligence. Engage in dialogue, ask questions, and receive intelligent responses to enhance your interactive communication experience.", style: TextStyle(color: lightTextColor), textAlign: TextAlign.center,),
                            SizedBox(height: 20,),
                            InkWell(
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                              onTap: (){
                                showModalBottomSheet<void>(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                  ),
                                  context: context,
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
                                                      itemCount: 10,
                                                      itemBuilder: (context, index) => Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: appPadding, vertical: appPadding/2),
                                                        child: Material(
                                                          color: bgColor,
                                                          borderRadius: BorderRadius.circular(appPadding),
                                                          child: InkWell(
                                                          borderRadius: BorderRadius.circular(appPadding),
                                                            onTap: (){},
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(appPadding),
                                                              child: Column(
                                                                children: [
                                                                  Text("Title", style: TextStyle(fontWeight: FontWeight.w500,  fontSize: 18),),
                                                                  Text("subTitle aasad sd sd asa", style: TextStyle(color: lightTextColor,  fontSize: 14),)
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
                    ),
                  );
                }else{
                  return Padding(
                    padding: const EdgeInsets.all(appPadding),
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: data.wait_response == false ? data.chat.length : data.chat.length + 1,
                      itemBuilder: (context, i) {
                        if (i >= data.chat.length) {
                          // Menampilkan pesan "Waiting for the answer" sebagai loading
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0.0), // Atur jarak antara item
                            // minVerticalPadding: -10,
                            isThreeLine: true,
                            dense: true,
                            leading: CircleAvatar(backgroundImage: AssetImage("assets/images/ChatGPT-logo-green_white.png"), radius: 14,),
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
                            leading: data.chat[i].role == "user" ? Icon(Icons.person) : CircleAvatar(backgroundImage: AssetImage("assets/images/ChatGPT-logo-green_white.png"), radius: 14,),
                            title: data.chat[i].role == "user" ? Text("You", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),) : Text("ChatGPT"),
                            subtitle: data.chat[i].role == "user"
                                ? Text(data.chat[i].content, style: TextStyle(fontSize: 14),)
                                : AnimatedTextKit(
                                    animatedTexts: [
                                      TypewriterAnimatedText(
                                        data.chat[i].content,
                                        textStyle: TextStyle(fontSize: 14.0),
                                        textAlign: TextAlign.start,
                                        speed: Duration(milliseconds: 50), 
                                      ),
                                    ],
                                    totalRepeatCount: 1, 
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
          _MessageBar(scrollController: scrollController,),
        ],
      ),
    );
  }                                     
}

class _MessageBar extends StatefulWidget {
  _MessageBar({
    Key? key,
    required this.scrollController
  }) : super(key: key);
  ScrollController scrollController;

  @override
  State<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<_MessageBar> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(appPadding),
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
                InkWell(
                  borderRadius: BorderRadius.circular(appPadding),
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    Provider.of<ChatState>(context, listen: false).addNewChat(ChatModel(role: "user", content: _textController.text));
                    _textController.clear();
                    Provider.of<ChatState>(context, listen: false).changeWaitResponse();

                    List<ChatModel> dataChat = Provider.of<ChatState>(context, listen: false).chat;
                    
                    List<Map<String, dynamic>> dataChatMap = dataChat.map((chat) {
                      return {
                        'role': chat.role,
                        'content': chat.content,
                      };
                    }).toList();
                    
                    ChatApiService.postChat(context, "gpt-3.5-turbo", dataChatMap);

                    widget.scrollController.animateTo(
                      widget.scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );


                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}