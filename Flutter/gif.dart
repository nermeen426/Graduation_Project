import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';  // Add this line
import 'package:flutter_ml/componant/constants.dart';
import 'package:flutter_ml/componant/custom_outline.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class GifScreen extends StatefulWidget {
  const GifScreen({super.key});
  @override
  State<GifScreen> createState() => _GifScreen();
}

class _GifScreen extends State<GifScreen> {
  String? base64_encoded_gif;
  File? flair_file;
  File? t1ce_file;
  final picker = ImagePicker();
  String? result;
  var url = "https://f554-156-211-79-89.ngrok-free.app/upload";
  Future pickFile1() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      flair_file = File(result.files.single.path!);
    }
    setState(() {});
  }
  Future pickFile2() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      t1ce_file = File(result.files.single.path!);
    }
    setState(() {});
  }
  upload() async {
    if (flair_file == null || t1ce_file == null) {
      // Handle the case when not all files are selected
      return;
    }
    final request = http.MultipartRequest("POST", Uri.parse(url));
    final header = {"Content-Type": "multipart/form-data"};

    request.files.add(http.MultipartFile(
      "flair_file",
      flair_file!.readAsBytes().asStream(),
      flair_file!.lengthSync(),
      filename: flair_file!.path.split('/').last,
    ));
    request.files.add(http.MultipartFile(
      "t1ce_file",
      t1ce_file!.readAsBytes().asStream(),
      t1ce_file!.lengthSync(),
      filename: t1ce_file!.path.split('/').last,
    ));
    request.headers.addAll(header);
    final myRequest = await request.send();
    http.Response res = await http.Response.fromStream(myRequest);
    if (myRequest.statusCode == 200) {
      final resJson = jsonDecode(res.body);
      print("response here: $resJson");
      base64_encoded_gif = resJson["base64_encoded_gif"];
    } else {
      print("Error ${myRequest.statusCode}");
    }
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Constants.kBlackColor,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Constants.kPinkColor,
        title: const Text(
          'Brain Tumor',
        ),
      ),
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Stack(
          children: [
            Positioned(
              top: screenHeight * 0.1,
              left: -88,
              child: Container(
                height: 166,
                width: 166,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Constants.kPinkColor,
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 200,
                    sigmaY: 200,
                  ),
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.3,
              right: -100,
              child: Container(
                height: 200,
                width: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Constants.kGreenColor,
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 200,
                    sigmaY: 200,
                  ),
                  child: Container(
                    height: 200,
                    width: 200,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.05),
              CustomOutline(
                strokeWidth: 4,
                radius: screenWidth * 0.8,
                padding: const EdgeInsets.all(4),
                width: screenWidth * 0.8,
                height: screenWidth * 0.8,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Constants.kPinkColor,
                    Constants.kPinkColor.withOpacity(0),
                    Constants.kGreenColor.withOpacity(0.1),
                    Constants.kGreenColor,
                  ],
                  stops: const [0.2, 0.4, 0.6, 1],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: base64_encoded_gif == null
                        ? DecorationImage(
                      fit: BoxFit.cover,
                      alignment: Alignment.bottomLeft,
                      image: AssetImage('assets/Brain.png'),
                    )
                        : DecorationImage(
                      fit: BoxFit.cover,
                      alignment: Alignment.bottomLeft,
                      image: MemoryImage(base64Decode(base64_encoded_gif!)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
                  Center(
                    child: base64_encoded_gif == null
                        ? Text(
                      'THE MODEL HAS NOT BEEN PREDICTED',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Constants.kWhiteColor.withOpacity(0.85),
                        fontSize: screenHeight <= 667 ? 18 : 34,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                        : Text(
                      'Result from 3d segmentation',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Constants.kWhiteColor.withOpacity(0.85),
                        fontSize: screenHeight <= 667 ? 18 : 34,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  CustomOutline(
                    strokeWidth: 3,
                    radius: 20,
                    padding: const EdgeInsets.all(3),
                    width: 160,
                    height: 38,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Constants.kPinkColor, Constants.kGreenColor],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Constants.kPinkColor.withOpacity(0.5),
                            Constants.kGreenColor.withOpacity(0.5),
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white12,
                        ),
                        onPressed: () {
                          pickFile1();
                        },
                        child: const Text(
                          'Pick First File',
                          style: TextStyle(
                            fontSize: 14,
                            color: Constants.kWhiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomOutline(
                    strokeWidth: 3,
                    radius: 20,
                    padding: const EdgeInsets.all(3),
                    width: 160,
                    height: 38,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Constants.kPinkColor, Constants.kGreenColor],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Constants.kPinkColor.withOpacity(0.5),
                            Constants.kGreenColor.withOpacity(0.5),
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white12,
                        ),
                        onPressed: () {
                          pickFile2();
                        },
                        child: const Text(
                          'Pick Second File',
                          style: TextStyle(
                            fontSize: 14,
                            color: Constants.kWhiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomOutline(
                    strokeWidth: 3,
                    radius: 20,
                    padding: const EdgeInsets.all(3),
                    width: 160,
                    height: 38,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Constants.kPinkColor, Constants.kGreenColor],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Constants.kPinkColor.withOpacity(0.5),
                            Constants.kGreenColor.withOpacity(0.5),
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white12,
                        ),
                        onPressed: () {
                          upload();
                        },
                        child: const Text(
                          'Upload',
                          style: TextStyle(
                            fontSize: 14,
                            color: Constants.kWhiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }
}
