import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as im;

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class Pmage {
  static Future<File> pickimage(ImageSource source) async {
    ImagePicker picker = ImagePicker();

    var tempImage = await picker.getImage(source: source,imageQuality: 50);

    File sampleImage = File(tempImage.path);

    return compressImage(sampleImage);
  }

  static Future<File> compressImage(File imageTOCompress) async {
    final tempdir = await getTemporaryDirectory();
    final path = tempdir.path;
    int random = Random().nextInt(10000);
    im.Image image = im.decodeImage(imageTOCompress.readAsBytesSync());
    im.copyResize(image, width: 500, height: 500);
    return File('$path/img_$random.jpg')
      ..writeAsBytesSync(im.encodeJpg(image, quality: 10));
  }


 
}
