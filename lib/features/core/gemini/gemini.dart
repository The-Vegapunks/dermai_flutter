import 'package:flutter_gemini/flutter_gemini.dart';
import 'dart:io';

class GeminiIntergace {
  String imgPath;
  String textIn;

  final gemini = Gemini.instance;

  GeminiIntergace(this.imgPath, this.textIn);

  String getOutput() {
    final file = File(imgPath);
    String output = "";
    gemini
        .textAndImage(text: textIn, images: [file.readAsBytesSync()])
        .then((value) => (output = (value?.content?.parts?.last.text ?? '')));
    return output;
  }
}
