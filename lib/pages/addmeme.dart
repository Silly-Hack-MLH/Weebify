import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_app/provider/imageprovider.dart';
import 'package:login_app/services/messageupload.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gallery_saver/gallery_saver.dart';

class HomePage1 extends StatefulWidget {
  final String senderid, reciverid;
  final IMageUploadProvider imageupp;
  HomePage1({this.imageupp, this.senderid, this.reciverid});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage1> {
  final GlobalKey globalKey = new GlobalKey();

  String headerText = "";
  String footerText = "";

  File _image;
  File _imageFile;

  bool imageSelected = false;

  Random rng = new Random();

  Future getImage() async {
    final picker = ImagePicker();
    var image, image1;
    image1 = await picker.getImage(source: ImageSource.gallery);
    try {
      setState(() {
        image = File(image1.path);
      });
    } catch (platformException) {
      print("not allowing " + platformException);
    }
    setState(() {
      if (image != null) {
        imageSelected = true;
      } else {}
      _image = image;
    });
    new Directory('storage/emulated/0/' + 'MemeGenerator')
        .create(recursive: true);
  }

  String albumName = 'Media';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 14,
              ),
              RepaintBoundary(
                key: globalKey,
                child: Stack(
                  children: <Widget>[
                    _image != null
                        ? Image.file(
                            _image,
                            height: 300,
                            fit: BoxFit.fitHeight,
                            width: MediaQuery.of(context).size.width,
                          )
                        : Container(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              headerText.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 26,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 3.0,
                                    color: Colors.black87,
                                  ),
                                  Shadow(
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 8.0,
                                    color: Colors.black87,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                footerText.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 26,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 3.0,
                                      color: Colors.black87,
                                    ),
                                    Shadow(
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 8.0,
                                      color: Colors.black87,
                                    ),
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              imageSelected
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            onChanged: (val) {
                              setState(() {
                                headerText = val;
                              });
                            },
                            decoration: InputDecoration(
                                hintText: "Header Text",
                                fillColor: Colors.white,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0))),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          TextField(
                            onChanged: (val) {
                              setState(() {
                                footerText = val;
                              });
                            },
                            decoration: InputDecoration(
                                hintText: "Footer Text",
                                fillColor: Colors.white,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0))),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          RaisedButton(
                            color: Colors.blueAccent,
                            onPressed: () {
                              takeScreenshot();
                              Future.delayed(
                                  Duration(
                                    seconds: 3,
                                  ),
                                  () => Navigator.pop(context));
                            },
                            child: Text(
                              "Save And Send",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(
                      child: Center(
                        child: Text("Select image to get started"),
                      ),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getImage();
        },
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  takeScreenshot() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    print(pngBytes);
    File imgFile = new File('$directory/screenshot${rng.nextInt(200)}.png');
    setState(() {
      _imageFile = imgFile;
    });
    _savefile(_imageFile);
    imgFile.writeAsBytes(pngBytes);
  }

  _savefile(File file) async {
    await _askPermission();
    GallerySaver.saveImage(file.path, albumName: albumName)
        .then((bool success) {
      Fluttertoast.showToast(
        msg: "Meme Saved in Gallery",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      print('Image is saved');
    });
    print(2);
    MessageSend().sendImage(
        _imageFile, widget.senderid, widget.reciverid, widget.imageupp);
  }

  _askPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.photos]);
  }
}
