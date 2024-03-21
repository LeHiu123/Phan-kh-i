// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  XFile? image;

  final ImagePicker picker = ImagePicker();
  Future _saveImageToGallery() async {
    if (image != null) {
      await ImageGallerySaver.saveFile(image!.path);
      showDialog(
          context: context,
          builder: (BuildContext context) =>
              AlertDialog(title: Text('save thành công')));
    }
  }

  Future _shareImage() async {
    if (image != null) {
      await Share.shareFiles([image!.path]);
    }
  }

  Future _download() async {
    if (image != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final savedImagePath = '${appDir.path}/$fileName.png';

      // Rename the XFile to the desired file path
      await image!.saveTo(savedImagePath);

      bool value = await io.File(savedImagePath).exists();

      if (value) {
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                AlertDialog(title: Text('thanh cong')));
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                AlertDialog(title: Text('that bai')));
      }
    }
  }

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  //show popup dialog
  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Hãy chọn phương thức lấy ảnh'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('Từ thư viện'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('Từ máy ảnh'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App chụp và chia sẻ ảnh'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                myAlert();
              },
              child: Text('Tải ảnh lên'),
            ),
            SizedBox(
              height: 10,
            ),
            //if image not null show the image
            //if image null show text
            image != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        //to show image, you type like this.
                        io.File(image!.path),
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                      ),
                    ),
                  )
                : Text(
                    "No Image",
                    style: TextStyle(fontSize: 20),
                  ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _saveImageToGallery();
              },
              child: Text('Lưu ảnh'),
            ),
            SizedBox(height: 14),
            ElevatedButton(
                onPressed: () {
                  _shareImage();
                },
                child: Text('Chia sẻ ảnh')),
          ],
        ),
      ),
    );
  }
}
