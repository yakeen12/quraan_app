import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';
import 'package:quraan/resources/images.dart';
import 'package:quraan/screens/home_page.dart';
import 'package:quraan/utils/colors.dart';

class CustomScaffold extends StatefulWidget {
  final String title;
  final Widget body;
  final bool showExit;
  const CustomScaffold(
      {super.key,
      required this.title,
      required this.body,
      required this.showExit});

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: widget.showExit
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 5, 8),
                  child: InkWell(
                      onTap: () => Get.offAll(HomePage()),
                      child: GlowText(
                        "خروج",
                        style: TextStyle(color: primaryColor1, fontSize: 16),
                      )),
                )
              : SizedBox(),
          centerTitle: true,
          title: GlowText(
            widget.title,
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
                    image: DecorationImage(
                        image: AssetImage(goldBg), fit: BoxFit.fill)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.body,
                ))));
  }
}
