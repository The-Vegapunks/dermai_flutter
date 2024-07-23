import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiIntergace {
  String textIn;

  final gemini = Gemini.instance;

  GeminiIntergace( this.textIn);

  String? getOutput(){
    String? output = "";
    gemini.text(textIn).then((value) => (output = (value?.output)));
    return output;
  }
}
