import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'dart:convert';

class PatientImage {
  late File imgPath;
  final picker = ImagePicker();

  PatientImage();

  void getImageFromGallery(ImageSource source) async {

    final image = await picker.pickImage(source: ImageSource.gallery);
    imgPath = File(image!.path);
  }

  void getImageFromCamera() async {
    final image = await  picker.pickImage(source: ImageSource.camera);
    imgPath = File(image!.path);
  }

  void sendImg() {
    // send request to python flask server
  }
}
