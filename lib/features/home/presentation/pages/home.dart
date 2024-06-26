import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shaka/constants/constants.dart';
import 'package:shaka/constants/responsive.dart';
import 'package:shaka/features/chats/presentation/pages/chats.dart';
import 'package:shaka/features/chats/provider/chat_state.dart';
import 'package:shaka/features/home/presentation/widgets/card_menu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shaka/features/image_generator/presentation/pages/chats.dart';
import 'package:shaka/features/image_generator/provider/chat_state.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      // appBar: AppBar(
      //   title: Text("Home", style: TextStyle(color: Colors.black)),
        
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: Responsive.screen_height(context)/12),
            Image.asset("assets/images/logo-app-black.png", scale: 5,),
            Text("SHAKA",  style: GoogleFonts.michroma(
              fontWeight: FontWeight.bold,
              fontSize: 18
            ),),
            const SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.all(appPadding-2),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(appPadding),
                child: InkWell(
                  borderRadius: BorderRadius.circular(appPadding),
                  onTap: (){
                    Provider.of<ChatState>(context,  listen: false).chat.clear();
                    Provider.of<ChatState>(context,  listen: false).changeLodaBtn(false);
                    Provider.of<ChatState>(context, listen: false).initVarChat("gpt-3.5-turbo", "assets/images/ChatGPT-logo-green_white.png", "GPT 3.5");
                    Provider.of<ChatState>(context, listen: false).changeIsFirstChat(true, 0);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Chat()));
                  },
                  child: const CardMenu(imageAsset: "assets/images/ChatGPT-logo-green_white.png", title: "ChatGPT", sub_title: "A chat prompt powered by ChatGPT technology.",),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(appPadding-2),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(appPadding),
                child: InkWell(
                  borderRadius: BorderRadius.circular(appPadding),
                  onTap: (){
                    Provider.of<ChatState>(context,  listen: false).chat.clear();
                    Provider.of<ChatState>(context,  listen: false).changeLodaBtn(false);
                    Provider.of<ChatState>(context, listen: false).initVarChat("gpt-4-turbo-preview", "assets/images/ChatGpt-Logo-black_white.png", "GPT 4");
                    Provider.of<ChatState>(context, listen: false).changeIsFirstChat(true, 0);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Chat()));
                  },
                  child: const CardMenu(imageAsset: "assets/images/ChatGpt-Logo-black_white.png", title: " GPT-4", sub_title: "A chat prompt powered by ChatGPT-4 technology.",),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(appPadding-2),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(appPadding),
                child: InkWell(
                  borderRadius: BorderRadius.circular(appPadding),
                  onTap: (){
                    Provider.of<ChatStateImage>(context,  listen: false).chat.clear();
                    Provider.of<ChatStateImage>(context,  listen: false).changeLodaBtn(false);
                    Provider.of<ChatStateImage>(context, listen: false).initVarChat("dall-e-3", "assets/images/Screenshot_2024-02-24_at_20.48.35-removebg-preview.png", "Image Generator");
                    Provider.of<ChatStateImage>(context, listen: false).changeIsFirstChat(true, 0);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatImage()));
                  },
                  child: const CardMenu(imageAsset: "assets/images/Screenshot_2024-02-24_at_20.48.35-removebg-preview.png", title: "Image Generator", sub_title: "Build your image with chat prompt.",),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}