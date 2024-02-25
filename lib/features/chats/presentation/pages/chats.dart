import 'package:flutter/material.dart';
import 'package:shaka/constants/constants.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
                    Text("Discover the revolutionary power of Open A I Gpt 3.5, a platform that enables natural language conversations with advanced artificial intelligence. Engage in dialogue, ask questions, and receive intelligent responses to enhance your interactive communication experience.", style: TextStyle(color: lightTextColor), textAlign: TextAlign.center,)
                  ],
                ),
              ),
            ),
          ),
          const _MessageBar(),
        ],
      ),
    );
  }
}

class _MessageBar extends StatefulWidget {
  const _MessageBar({
    Key? key,
  }) : super(key: key);

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
                      autofocus: true,
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
                  onTap: () => null,
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