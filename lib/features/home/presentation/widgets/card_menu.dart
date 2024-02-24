import 'package:flutter/material.dart';
import 'package:shaka/constants/constants.dart';
import 'package:shaka/constants/responsive.dart';

class CardMenu extends StatelessWidget {
  const CardMenu({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.sub_title
  });

  final String imageAsset;
  final String title;
  final String sub_title;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        width: Responsive.screen_width(context),
        height: 120,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(appPadding),
              child: Image(image: AssetImage(imageAsset)),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title, 
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18
                    ),
                  ),
                  const SizedBox(height: appPadding/2,),
                  Text(
                    sub_title, 
                    style: const TextStyle(
                      color: lightTextColor
                    ), 
                    textAlign: TextAlign.center,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}