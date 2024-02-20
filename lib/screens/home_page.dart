import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';
import 'package:quraan/resources/images.dart';
import 'package:quraan/utils/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List names = [
    "الدّورة التمهيدية",
    "الدّورة المتوسطة",
    "الدّورة المتقدمة",
    "دورة الاتقان",
    "دورة الاجازة",
  ];

  List onTaps = [
    () => Get.toNamed('/multiple_q'),
    () {},
    () {},
    () {},
    () {},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        title: const GlowText(
          "إقرأ باسم ربّك",
          style: TextStyle(color: primaryColor1),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(metalGreen), fit: BoxFit.fill)),
        ),
      ),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
              image:
                  DecorationImage(image: AssetImage(goldBg), fit: BoxFit.fill)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GlowText(
                          style: TextStyle(
                              fontSize: 20,
                              color: primaryColor2,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                          ":من فضلك اختر الامتحان",
                        ),
                      ],
                    ),
                  ),
                ),
                ...List.generate(
                    5,
                    (index) => InkWell(
                          onTap: () {
                            Get.toNamed('/quiz', arguments: 2);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.transparent,
                            ),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                    image: AssetImage(metalGreen),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GlowText(
                                      names[index],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: (primaryColor1),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
