import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';
import 'package:quraan/models/match_q_model.dart';
import 'package:quraan/resources/images.dart';
import 'package:quraan/utils/colors.dart';
import 'package:quraan/widgets/CustomRadioButton.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class MatchQView extends StatefulWidget {
  final MatchQuestion question;
  final Function(String) updateChoice;
  const MatchQView(
      {super.key, required this.question, required this.updateChoice});

  @override
  State<MatchQView> createState() => _MatchQViewState();
}

class _MatchQViewState extends State<MatchQView> {
  late MatchQuestion _question;
  late List<String> col1;
  late List<String> col2;

  var col1Val = "";
  var col2Val = "";

  int counter1 = 0;
  int counter2 = 0;
  int counterAll = 1;

  List<String> nullButtons = [];

  @override
  void initState() {
    super.initState();
    _question = widget.question;
    col1 = _question.pairs.values.toList();
    col2 = _question.pairs.keys.toList();
    col1.shuffle();
    col2.shuffle();
    printError(info: "col1: $col1");
    printError(info: "col2: $col2");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
              image:
                  DecorationImage(image: AssetImage(goldBg), fit: BoxFit.fill)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.transparent,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                          image: AssetImage(metalGreen), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GlowText(
                            'صل ما يلي',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                fontSize: 20,
                                color: (primaryColor1),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ...List.generate(
                  _question.pairs.length,
                  growable: true,
                  (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: ChoiceButton(
                            option: col1[index],
                            // option: _question.choices![index],
                            isSelected: col1Val == col1[index].toString(),
                            onPressed:
                                nullButtons.contains(col1[index].toString())
                                    ? null
                                    : () {
                                        col1Val = col1[index].toString();
                                        counter1 = counterAll;
                                        print(col1Val);
                                        setState(() {});
                                        check();
                                      },
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: ChoiceButton(
                            option: col2[index],
                            // option: _question.choices![index],
                            isSelected: col2Val == col2[index].toString(),
                            onPressed:
                                nullButtons.contains(col2[index].toString())
                                    ? null
                                    : () {
                                        col2Val = col2[index].toString();
                                        counter2 = counterAll;
                                        print(col2Val);
                                        setState(() {});
                                        check();
                                      },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  check() async {
    if ((counter1 == counter2)) {
      {
        if (counter1 == counterAll) {
          if (widget.question.pairs[col2Val] == col1Val) {
            printError(info: "right !!!!");
            nullButtons.add(col1Val);
            nullButtons.add(col2Val);
            col1Val = "";
            col2Val = "";
            counterAll++;
            AudioPlayer().play(
              position: const Duration(milliseconds: 300),
              AssetSource(
                'correct.mp3',
              ),
            );

            if (counterAll > col1.length) {
              printError(info: "updated");
              setState(() {
                widget.updateChoice("");
              });
            }
          } else {
            printError(info: "Wrong :(((())))");
            // Vibrate the device when the answer is wrong
            if (await Vibration.hasVibrator() ?? false) {
              Vibration.vibrate(duration: 500); // Vibrate for 500 milliseconds
            }
            AudioPlayer().play(
              position: const Duration(milliseconds: 300),
              AssetSource(
                'wrong.mp3',
              ),
            );
          }
        }
      }
    }
  }
}
