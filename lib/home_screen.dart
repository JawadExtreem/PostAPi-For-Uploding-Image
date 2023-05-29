import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? image;
  final _picker = ImagePicker();
  bool showSpinner = false;
  Future getImage () async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery , imageQuality: 80);

    if(pickedFile!= null) {
      image =File (pickedFile.path);
      setState(() {

      });
    }else {
      print('no image selected');
    }

  }
  // function for uploading image

  Future<void> uploadImage () async {

    setState(() {
      showSpinner = true;
    });

    var stream = new http.ByteStream(image!.openRead());
    stream.cast();

    var length = await image!.length();

    var uri =Uri.parse('https://fakestoreapi.com/products');

    var request = new http.MultipartRequest('POST', uri);

    request.fields['title'] = "static title";

    var multiport = new http.MultipartFile('iamge', stream, length);

    request.files.add(multiport);

    var response = await request.send();

    if(response. statusCode == 200){
      setState(() {
        showSpinner = false;
      });
      print('image uploaded successfully');

    }else{
      setState(() {
        showSpinner = false;
      });
      print('Failed to uploaded');

    }


  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Uploading Images'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                getImage ();
              },
              child: Container(
                child: image == null ? Center(child: Text('Pick Image'),):
                    Container(
                      child: Center(
                        child: Image.file(
                          File(image!.path).absolute,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ) ,),
                    ),
              ),
            ),
            SizedBox(height: 150,),

            GestureDetector(
              onTap: () {
                uploadImage();
              },
              child: Container(
                height: 50,
                width: 100,
                color: Colors.green,
                child: Center(child: Text('image upload')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
