import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiInterface {
  String textIn;

  final gemini = Gemini.instance;

  GeminiInterface( this.textIn);

  String? getOutput(){
    String? output = "";
    gemini.text(textIn).then((value) => (output = (value?.output)));
    return output;
  }
}
