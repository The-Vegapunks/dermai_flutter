import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class PatientImage {
  late File image;
  final picker = ImagePicker();

  PatientImage();

  void getImageFromGallery({required Function onImageSelect}) async {
    final imageWrapper = await picker.pickImage(source: ImageSource.gallery);
    image = File(imageWrapper!.path);
    onImageSelect(image);
  }

  void getImageFromCamera() async {
    final imageWrapper = await picker.pickImage(source: ImageSource.camera);
    image = File(imageWrapper!.path);
  }

  Future<String?> sendImg(String Filename) async {
    // send request to python flask server
    var postURi = Uri.parse("URi here");

    var request = http.MultipartRequest("POST", postURi);

    request.files.add(http.MultipartFile.fromBytes(
        Filename, File.fromRawPath(image.readAsBytesSync()).readAsBytesSync(),
        contentType: MediaType('image', 'jpeg')));

    var response = request.send();

    

    var responseData = response.asStream();

    return jsonDecode(responseData.toString());
  }
}
