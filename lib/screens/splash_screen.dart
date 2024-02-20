import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quraan/resources/images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 1),
      () {
        Get.offAndToNamed('/home');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              logo,
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            const SizedBox(
              height: 10,
            ),
            const AutoSizeText(
              "جمعية المحافظة على القرآن الكريم",
              minFontSize: 15,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const AutoSizeText(
              "اختبارات تجريبية",
              minFontSize: 15,
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
