import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ensure_visible_when_focused/ensure_visible_when_focused.dart';
import 'package:flutter/material.dart';
import 'package:mysrapp/views/result.screen.dart';
import 'package:screenshot/screenshot.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  late GlobalKey<FormState> _formKey;
  late FocusNode _focusNode;

  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                'Poster',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
              ),
              const SizedBox(height: 30),
              StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('poster').snapshots(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    if (snapshot.hasData &&
                        (snapshot.data! as QuerySnapshot).docs.isNotEmpty) {
                      var doc = (snapshot.data! as QuerySnapshot).docs[0];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: SingleChildScrollView(
                          child: Screenshot(
                            controller: screenshotController,
                            child: Column(
                              children: [
                                Image.network(
                                  doc['posterImageUrl'],
                                  // height: height * 0.5,
                                  // width: double.infinity,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    return Center(child: child);
                                  },
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return const Text('Failed to load image');
                                  },
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 100,
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 50,
                                              width: width - 130,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(),
                                              ),
                                              child: EnsureVisibleWhenFocused(
                                                focusNode: _focusNode,
                                                child: TextFormField(
                                                  focusNode: _focusNode,
                                                  decoration:
                                                      const InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(5),
                                                    border: InputBorder.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 50,
                                              width: width - 130,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(),
                                              ),
                                              child: TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(10),

                                                  isDense: true,
                                                  prefixIcon: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 12),
                                                    child:
                                                        Text(" Created by  "),
                                                  ),
                                                  // prefixText: " Created by ",
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        color: Colors.white,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                              'assets/logo.png',
                                              height: 84,
                                              width: 84,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
              ),
              const SizedBox(
                height: 75,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: takeScreenshot,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 126, 63, 181),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  takeScreenshot() {
    showDialog(
      context: context,
      builder: ((context) {
        return Dialog(
          child: SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text(
                  'Generating Result',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                CircularProgressIndicator()
              ],
            ),
          ),
        );
      }),
    );
    screenshotController.capture().then((Uint8List? image) {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => ResultScreen(image: image!))));
    }).catchError((onError) {});
  }
}
