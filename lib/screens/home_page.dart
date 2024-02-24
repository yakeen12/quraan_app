import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';
import 'package:quraan/resources/images.dart';
import 'package:quraan/utils/colors.dart';
import 'package:quraan/widgets/customScaffold.dart';

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

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showExit: false,
      title: "إقرأ باسم ربّك",
      body: Column(
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
                      Get.toNamed('/quiz', arguments: index + 1);
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
                              image: AssetImage(metalGreen), fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        width: MediaQuery.of(context).size.width,
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
                      ),
                    ),
                  ))
        ],
      ),
    );
  }
}
