import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:shaka/env.dart';
import 'package:shaka/features/history/model/chat_history_model.dart';
import 'package:shaka/features/image_generator/model/chat_model.dart';
import 'package:shaka/features/image_generator/provider/chat_state.dart';
import 'package:shaka/global_widgets/alert_widget.dart';
import 'package:shaka/helper/helper.dart';
import 'package:shaka/local_services/sqlite_service.dart';

class ChatImageApiService{
  static Future postChat(context , String model, String message, String img_model, String model_name) async {
    bool is_first_chat = Provider.of<ChatStateImage>(context, listen: false).is_first_chat;
    int id = Provider.of<ChatStateImage>(context, listen: false).id;
    String exMsg = 'GPT-4 is a large multimodal model (accepting text or image inputs and outputting text) that can solve difficult problems with greater accuracy than any of our previous models, thanks to its broader general knowledge and advanced reasoning capabilities. GPT-4 is available in the OpenAI API to paying customers. Like gpt-3.5-turbo, GPT-4 is optimized for chat but works well for traditional completions tasks using the Chat Completions API. Learn how to use GPT-4 in our text generation guide.';

    await Future.delayed(Duration(seconds: 2));
    Provider.of<ChatStateImage>(context, listen: false).changeWaitResponse();
    String converted_img = await convertImgBase64('https://res.cloudinary.com/kwul0208/image/upload/v1658222901/cld-sample-5.jpg');
    Provider.of<ChatStateImage>(context, listen: false).addNewChat(ChatModelImage(role: 'assistant', revised_prompt: exMsg, url: converted_img));

    
    if (is_first_chat) {
      print("frist");
      final int createdItemId = await SqliteService.createItem(ChatHistoryModel(id: 2, img_model: img_model, model_name: model_name, first_message: cutString(message, 60), updated_at: DateTime.now().toString(), local: 'true'));

      await SqliteService.createItemDetailImage(ChatModelImage(chat_id: createdItemId ,role: 'user', revised_prompt: message, created_at: DateTime.now().toString(), url: '', local: 'true'));
      await SqliteService.createItemDetailImage(ChatModelImage(chat_id: createdItemId ,role: 'assistant', revised_prompt: exMsg, created_at: DateTime.now().toString(), url: converted_img, local: 'true'));
      Provider.of<ChatStateImage>(context, listen: false).changeIsFirstChat(false, createdItemId);
    } else {
      print("second");
      SqliteService.editItem(ChatHistoryModel(id: id, img_model: img_model, model_name: model_name, first_message: cutString(message, 60), updated_at: DateTime.now().toString(), local: 'true'));
      await SqliteService.createItemDetailImage(ChatModelImage(chat_id: id ,role: 'user', revised_prompt: message, created_at: DateTime.now().toString(), url: '', local: 'true'));
      await SqliteService.createItemDetailImage(ChatModelImage(chat_id: id ,role: 'assistant', revised_prompt: exMsg, created_at: DateTime.now().toString(), url: converted_img, local: 'true'));
    }
    return {'status': 200, 'message': 'Success'};
    // print(message);return null;
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': '${gptToken}'
      };

      var request = http.Request('POST', Uri.parse('${gptUrl}/v1/images/generations'));
      request.body = json.encode({
        "prompt": message,
        "n": 1,
        "size": "1024x1024",
        "model": model
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Provider.of<ChatStateImage>(context, listen: false).changeWaitResponse();
        Map res = json.decode(await response.stream.bytesToString());
        print(res);
          Provider.of<ChatStateImage>(context, listen: false).addNewChat(ChatModelImage(role: 'assistant', revised_prompt: res['data'][0]['revised_prompt'], url: res['data'][0]['url']));
          return {'status': 200, 'message': 'Success'};
      }else {
        print(response.reasonPhrase);
        Provider.of<ChatStateImage>(context, listen: false).changeWaitResponse();
        alertFailed(context, 'Failed, ${response.reasonPhrase}');
        return {'status': 500, 'message': 'Gagal ${response.reasonPhrase}'};
      }

    } catch (e) {
      Provider.of<ChatStateImage>(context, listen: false).changeWaitResponse();
      alertFailed(context, 'Failed, ${e}');
      return {'status': 500, 'message': 'Gagal ${e}'};
    }
  }

  static Future saveImage(String base64String)async{
    // var response = await Dio().get(
    //     image_url,
    //     options: Options(responseType: ResponseType.bytes));
    //     final result = await ImageGallerySaver.saveImage(
    //     Uint8List.fromList(response.data),
    //     quality: 60,
    //     name: "Shaka GPT");

    Uint8List bytes = base64Decode(base64String);

    final result = await ImageGallerySaver.saveImage(
      bytes,
      quality: 60,
      name: "Shaka GPT",
    );

    return  result;
  }
}