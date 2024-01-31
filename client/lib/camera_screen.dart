import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'package:http_parser/http_parser.dart'; // Import the http_parser package
import 'dart:convert';
import 'result_screen.dart'; // Import the result screen

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraScreen({required this.cameras});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> takePicture() async {
    if (!controller.value.isInitialized) {
      print('Error: select a camera first.');
      return;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${DateTime.now().millisecondsSinceEpoch}.jpg';

    if (controller.value.isTakingPicture) {
      return;
    }

    try {
      XFile picture = await controller.takePicture();
      sendImageToAPI(picture); // Sends the image to the API and navigates to the result screen
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendImageToAPI(XFile picture) async {
    var uri = Uri.parse('aabidraina.pythonanywhere.com');
    var request = http.MultipartRequest('POST', uri);

    // ...

    request.files.add(await http.MultipartFile.fromPath(
      'picture',
      picture.path,
      contentType: MediaType.parse('image/jpeg'), // Use MediaType.parse instead of MediaType
    ));

    var response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      var decodedResponse = json.decode(responseBody);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(result: decodedResponse['result']),
        ),
      );
    } else {
      print('Failed to send image to API');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(title: Text('Take a Picture')),
      body: CameraPreview(controller),
      floatingActionButton: FloatingActionButton(
        onPressed: takePicture,
        child: Icon(Icons.camera),
      ),
    );
  }
}
