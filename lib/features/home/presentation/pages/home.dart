import 'package:flutter/material.dart';
import 'package:shaka/constants/constants.dart';
import 'package:shaka/constants/responsive.dart';
import 'package:shaka/features/chats/presentation/pages/chats.dart';
import 'package:shaka/features/home/presentation/widgets/card_menu.dart';
import 'package:google_fonts/google_fonts.dart';

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
                  onTap: (){},
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
                  onTap: (){},
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