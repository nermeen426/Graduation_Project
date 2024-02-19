import 'package:flutter/material.dart';
import 'package:flutter_ml/seg.dart';
import 'package:flutter_ml/Ml Model.dart';
import 'package:flutter_ml/gif.dart';
class ChoicePage extends StatelessWidget {
  const ChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xff55598d),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return  seg();
                    }),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  height: 60,
                  width: 350,
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text('segmentation'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Add a button for 3D Segmentation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const GifScreen(); // Use the correct class for Gif screen
                    }),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  height: 60,
                  width: 350,
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text('3D Segmentation'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return  MlModel();
                    }),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  height: 60,
                  width: 350,
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text('classification'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
