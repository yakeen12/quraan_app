import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';
import 'package:quraan/resources/images.dart';
import 'package:quraan/screens/quiz_screen.dart';
import 'package:quraan/utils/colors.dart';
import 'package:quraan/views/match_q_view.dart';
import 'package:quraan/views/multi_q_view.dart';
import 'package:quraan/widgets/customScaffold.dart';

class CorrectMistakes extends StatefulWidget {
  const CorrectMistakes({
    required this.questions,
    required this.quizLength,
    super.key,
  });
  final List<dynamic> questions;
  final int quizLength;

  @override
  State<CorrectMistakes> createState() => _CorrectMistakesState();
}

class _CorrectMistakesState extends State<CorrectMistakes> {
  late PageController _pageController;
  int currentPageIndex = 0;

  List<dynamic> _questions = [];

  @override
  void initState() {
    super.initState();
    updateQuestionsUpdateChoice();
    _pageController = PageController();
  }

  updateQuestionsUpdateChoice() {
    widget.questions.forEach((element) {
      if (element.runtimeType == Multi_q_view) {
        _questions.add(Multi_q_view(
          question: element.question,
          updateChoice: updateChoice,
        ));
      } else {
        _questions.add(
            MatchQView(question: element.question, updateChoice: updateChoice));
      }
    });
  }

  void updateChoice(String option) {
    if (_questions[currentPageIndex].runtimeType == Multi_q_view) {
      _questions[currentPageIndex].question!.selectedOption = option;
    }
    _questions[currentPageIndex].question.isButtonPressable = true;
    setState(() {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void checkAnswer(BuildContext context) {
    // check result
    String result;
    String correctAnswerText = "";

    if (_questions[currentPageIndex].runtimeType == Multi_q_view) {
      result = _questions[currentPageIndex].question.selectedOption ==
              _questions[currentPageIndex].question.rightAnswer
          ? '!إجابة صحيحة'
          : 'إجابة خاطئة';
      correctAnswerText =
          _questions[currentPageIndex].question.selectedOption !=
                  _questions[currentPageIndex].question.rightAnswer
              ? ':الإجابة الصحيحة هي'
              : '';
      printError(info: _questions[currentPageIndex].question.selectedOption);
      printError(info: "quizLength = ${widget.quizLength}");
    } else {
      result = '!إجابة صحيحة';
    }

    AudioPlayer().play(
      position: const Duration(milliseconds: 350),
      AssetSource(
        result == '!إجابة صحيحة' ? 'correct.mp3' : 'wrong.mp3',
      ),
    );

    // show modal
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: const Color.fromARGB(205, 0, 0, 0),
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    result,
                    style: TextStyle(
                        fontSize: 25.0,
                        color: correctAnswerText.isNotEmpty
                            ? Colors.red
                            : Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Icon(
                    correctAnswerText.isNotEmpty
                        ? Icons.cancel
                        : Icons.check_circle,
                    color: correctAnswerText.isNotEmpty
                        ? Colors.red
                        : Colors.green,
                    size: 50,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (correctAnswerText.isNotEmpty)
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        correctAnswerText,
                        style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        _questions[currentPageIndex].question.rightAnswer!,
                        style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    navigator!.pop(context);
                    if (currentPageIndex < _questions.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    } else {
                      Get.toNamed(
                        '/score',
                        arguments: {
                          'quizLength': widget.quizLength,
                          'wrongLength': _questions.length
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    backgroundColor:
                        result == '!إجابة صحيحة' ? Colors.green : Colors.red,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    correctAnswerText.isNotEmpty ? 'فهمت' : 'أكمل',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _questions.isEmpty
        ? Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(goldBg), fit: BoxFit.fill)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "جاري احضار الاسئلة",
                      style: TextStyle(
                          color: Colors.green[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CircularProgressIndicator(
                      color: Colors.green[900],
                    ),
                  ],
                ),
              ),
            ),
          )
        : CustomScaffold(
            showExit: true,
            title: "مراجعة الأخطاء",
            body: Column(children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.864,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _questions.length,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    printInfo(
                        info: "${_questions[currentPageIndex].runtimeType}");
                    setState(() {
                      currentPageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.724,
                            child: _questions[index]),
                        InkWell(
                          onTap: () {
                            _questions[currentPageIndex]
                                    .question
                                    .isButtonPressable
                                ? checkAnswer(context)
                                : null;
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            height: MediaQuery.of(context).size.height * 0.1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.transparent,
                            ),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: _questions[currentPageIndex]
                                          .question
                                          .isButtonPressable
                                      ? const AssetImage(metalGreen)
                                      : const AssetImage(nullColor),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GlowText(
                                      "تحقق",
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
                        ),
                      ],
                    );
                  },
                ),
              ),
            ]),
          );
  }
}
