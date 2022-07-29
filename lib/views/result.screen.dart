import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ResultScreen extends StatefulWidget {
  final Uint8List image;
  const ResultScreen({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Result',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
              ),
              const SizedBox(height: 30),
              Image.memory(widget.image),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: _shareImage,
                child: Container(
                  width: width * 0.5,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 126, 63, 181),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Share',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _shareImage() async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    File imgFile = File('$directory/screenshot.png');
    imgFile.writeAsBytes(widget.image);
    await Share.shareFiles(
      [imgFile.path],
      text: "sharing poster !!",
      subject: 'Sharing poster !',
    );
  }
}
