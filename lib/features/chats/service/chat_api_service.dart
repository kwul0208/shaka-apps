import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shaka/constants/constants.dart';
import 'package:shaka/env.dart';
import 'package:shaka/features/chats/model/chat_model.dart';
import 'package:shaka/features/chats/provider/chat_state.dart';
import 'package:shaka/global_widgets/alert_widget.dart';

class ChatApiService{
  static Future postChat(context , model, List message) async {
    await Future.delayed(Duration(seconds: 2));
    Provider.of<ChatState>(context, listen: false).changeWaitResponse();
    Provider.of<ChatState>(context, listen: false).addNewChat(ChatModel(role: 'assistant', content: 'GPT-4 is a large multimodal model (accepting text or image inputs and outputting text) that can solve difficult problems with greater accuracy than any of our previous models, thanks to its broader general knowledge and advanced reasoning capabilities. GPT-4 is available in the OpenAI API to paying customers. Like gpt-3.5-turbo, GPT-4 is optimized for chat but works well for traditional completions tasks using the Chat Completions API. Learn how to use GPT-4 in our text generation guide.'));
          return {'status': 200, 'message': 'Success'};
    // print(message);return null;
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': '${gptToken}'
      };

      var request = http.Request('POST', Uri.parse('${gptUrl}/v1/chat/completions'));
      request.body = json.encode({
        "model": model,
        "messages": message,
        "temperature": 1,
        "top_p": 1,
        "n": 1,
        "stream": false,
        "max_tokens": 250,
        "presence_penalty": 0,
        "frequency_penalty": 0
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Provider.of<ChatState>(context, listen: false).changeWaitResponse();
        Map res = json.decode(await response.stream.bytesToString());
        print(res);
          Provider.of<ChatState>(context, listen: false).addNewChat(ChatModel(role: res['choices'][0]['message']['role'], content: res['choices'][0]['message']['content']));
          return {'status': 200, 'message': 'Success'};
      }else {
        print(response.reasonPhrase);
        Provider.of<ChatState>(context, listen: false).changeWaitResponse();
        alertFailed(context, 'Failed, ${response.reasonPhrase}');
        return {'status': 500, 'message': 'Gagal ${response.reasonPhrase}'};
      }

    } catch (e) {
      Provider.of<ChatState>(context, listen: false).changeWaitResponse();
      alertFailed(context, 'Failed, ${e}');
      return {'status': 500, 'message': 'Gagal ${e}'};
    }
  }

}