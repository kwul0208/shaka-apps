
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shaka/constants/constants.dart';
import 'package:shaka/constants/responsive.dart';
import 'package:shaka/features/image_generator/model/chat_model.dart';
import 'package:shaka/features/image_generator/model/data_example_img.dart';
import 'package:shaka/features/image_generator/presentation/widgets/BuildImage.dart';
import 'package:shaka/features/image_generator/provider/chat_state.dart';
import 'package:shaka/features/image_generator/service/chat_api_service.dart';
import 'package:shaka/global_widgets/alert_widget.dart';
import 'package:shaka/local_services/sqlite_service.dart';


class ChatImage extends StatefulWidget {
  ChatImage({super.key, this.chat_id});
  final int? chat_id;


  @override
  State<ChatImage> createState() => _ChatImageState();
}

class _ChatImageState extends State<ChatImage> {
  List<ChatModelImage> chats = [];

  ScrollController scrollController = ScrollController();
  ScrollController scrollControllerChat = ScrollController();

  @override
  void initState() {
    super.initState();
    if(widget.chat_id != null) getDetailChat(widget.chat_id);

  }


  @override
  Widget build(BuildContext context) {
    var dataState = Provider.of<ChatStateImage>(context, listen: false);
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
            child: Consumer<ChatStateImage>(
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
                                                    itemCount: data_example_img.length,
                                                    itemBuilder: (context, index) => Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: appPadding, vertical: appPadding/2),
                                                      child: Material(
                                                        color: bgColor,
                                                        borderRadius: BorderRadius.circular(appPadding),
                                                        child: InkWell(
                                                        borderRadius: BorderRadius.circular(appPadding),
                                                          onTap: (){
                                                            Provider.of<ChatStateImage>(scaffoldContext, listen: false).addNewChat(ChatModelImage(role: "user", revised_prompt: data_example_img[index]['value']));
                                                            ChatImageApiService.postChat(scaffoldContext, data.model, data_example_img[index]['value'], data.img, data.model_name);
                                                            Provider.of<ChatStateImage>(scaffoldContext, listen: false).changeWaitResponse();
                                                            Provider.of<ChatStateImage>(scaffoldContext, listen: false).changeLodaBtn(true);
                                                            Navigator.pop(context);
                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(appPadding),
                                                            child: Column(
                                                              children: [
                                                                Text(data_example_img[index]['title'], style: TextStyle(fontWeight: FontWeight.w500,  fontSize: 18),),
                                                                Text(data_example_img[index]['subtitle'], style: TextStyle(color: lightTextColor,  fontSize: 14),)
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
                            leading: CircleAvatar(backgroundImage: AssetImage(dataState.img), radius: 14,),
                            title: Text(dataState.model_name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            subtitle: Align(
                              alignment: Alignment.centerLeft, // Posisikan teks animasi di kiri
                              child: DefaultTextStyle(
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: lightTextColor
                                ),
                                child: AnimatedTextKit(
                                  animatedTexts: [
                                    WavyAnimatedText('Generating your image...', speed: Duration(milliseconds: 100)),
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
                                ? Text(data.chat[i].revised_prompt, style: TextStyle(fontSize: 14),)
                                : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AnimatedTextKit(
                                        animatedTexts: [
                                          TypewriterAnimatedText(
                                            "Revised Prompt:  ${data.chat[i].revised_prompt}",
                                            textStyle: TextStyle(fontSize: 14.0),
                                            textAlign: TextAlign.start,
                                            speed: widget.chat_id == null ? Duration(milliseconds: 10) : Duration.zero, //history condition
                                          ),
                                        ],
                                        isRepeatingAnimation: false,
                                        totalRepeatCount: 1,
                                        onFinished: (){
                                          Provider.of<ChatStateImage>(context, listen: false).changeLodaBtn(false);
                                        },
                                    
                                      ),
                                    // if(data.chat[i].url!.isNotEmpty) Image.network(data.chat[i].url!, scale: 3,),
                                    if(data.chat[i].url!.isNotEmpty) buildImage(context, data.chat[i].url!, 8),
                                    if(data.chat[i].role == 'assistant')
                                      Builder(
                                        builder: (context) {
                                          if(i != data.chat.length - 1){
                                            return Row(
                                              children: [
                                                TextButton.icon(
                                                  onPressed: (){
                                                    Clipboard.setData(ClipboardData(text: data.chat[i].revised_prompt));
                                                    alert(context, "Copied!");
                                                  }, 
                                                  icon: Icon(Icons.copy, color: Colors.black, size: 16,),
                                                  label: Text("Copy Text", style: TextStyle(color: Colors.black, fontSize: 11)),
                                                ),
                                                TextButton.icon(
                                                  onPressed: (){
                                                    Clipboard.setData(ClipboardData(text: data.chat[i].revised_prompt));
                                                    alert(context, "Saved image to gallery!");
                                                  }, 
                                                  icon: Icon(Icons.file_download_outlined, color: Colors.black, size: 16,),
                                                  label: Text("Save Image", style: TextStyle(color: Colors.black, fontSize: 11)),
                                                ),
                                              ],
                                            );
                                          }else{
                                            if (!data.lodaBtn) {
                                              // return SizedBox();
                                              return Row(
                                                children: [
                                                  TextButton.icon(
                                                    onPressed: (){
                                                      Clipboard.setData(ClipboardData(text: data.chat[i].revised_prompt));
                                                      alert(context, "Copied!");
                                                    }, 
                                                    icon: Icon(Icons.copy, color: Colors.black, size: 16,),
                                                    label: Text("Copy Text", style: TextStyle(color: Colors.black, fontSize: 11)),
                                                  ),
                                                  TextButton.icon(
                                                    onPressed: (){
                                                      // Clipboard.setData(ClipboardData(text: data.chat[i].revised_prompt));
                                                      ChatImageApiService.saveImage(data.chat[i].url!);
                                                      alert(context, "Saved image to gallery!");
                                                    }, 
                                                    icon: Icon(Icons.file_download_outlined, color: Colors.black, size: 16,),
                                                    label: Text("Save Image", style: TextStyle(color: Colors.black, fontSize: 11)),
                                                  ),
                                                ],
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
    chats = await SqliteService.getItemsDetailImage(chat_id);
    print("chats ${widget.chat_id}");
    print(chats);
    for (var e in chats) {
      print([e.revised_prompt,  e.role, e.url, e.url]);
    }
    Provider.of<ChatStateImage>(context, listen: false).initChat(chats);
  }                                 
}

class _MessageBar extends StatefulWidget {
  _MessageBar({
    Key? key,
    required this.scrollControllerChat,
    required this.dataState
  }) : super(key: key);
  ScrollController scrollControllerChat;
  ChatStateImage dataState;

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
                Consumer<ChatStateImage>(
                  builder: (context, data, _) {
                    if (data.lodaBtn) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(appPadding),
                        onTap: null,
                        // onTap: () {
                        //   Provider.of<ChatStateImage>(context, listen: false).changeLodaBtn(false);
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
                          // return null;
                          FocusScope.of(context).unfocus();
                          Provider.of<ChatStateImage>(context, listen: false).addNewChat(ChatModelImage(role: "user", revised_prompt: _textController.text));
                          Provider.of<ChatStateImage>(context, listen: false).changeWaitResponse();
                          Provider.of<ChatStateImage>(context, listen: false).changeLodaBtn(true);
                          ChatImageApiService.postChat(context, widget.dataState.model, _textController.text, data.img, data.model_name);
                          _textController.clear();
                      
                          // widget.scrollControllerChat.animateTo(
                          //   widget.scrollControllerChat.position.maxScrollExtent,
                          //   duration: Duration(milliseconds: 30),
                          //   curve: Curves.easeOut,
                          // );
                      
                      
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