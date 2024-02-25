import 'package:get/get.dart';
import 'package:quraan/models/match_q_model.dart';
import 'package:quraan/models/multi_q_model.dart';
import 'package:quraan/screens/correct_mistakes_page.dart';
import 'package:quraan/services/match_q_services.dart';
import 'package:quraan/services/multi_q_services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:quraan/resources/images.dart';
import 'package:quraan/utils/colors.dart';
import 'package:quraan/views/match_q_view.dart';
import 'package:quraan/views/multi_q_view.dart';
import 'package:quraan/widgets/customScaffold.dart';

class QuizPage extends StatefulWidget {
  final int level;
  const QuizPage({super.key, required this.level});

  @override
  State<QuizPage> createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  late PageController _pageController;
  int currentPageIndex = 0;

  List<MultiQuestion> _MultiQuestions = [];
  List<MatchQuestion> _MatchQuestions = [];

  List<Multi_q_view> _MultiQuestionsViews = [];
  List<MatchQView> _MatchQuestionsViews = [];

  List qs = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    getData();
  }

  getData() async {
    await _fetchMultiQuestions();
    await _fetchMatchQuestions();
    qs.shuffle();

    qs.forEach((element) {
      printError(info: "element: $element, DataType: ${element.runtimeType}");
    });
    setState(() {});
  }

  void updateChoice(String option) {
    if (qs[currentPageIndex].runtimeType == Multi_q_view) {
      qs[currentPageIndex].question!.selectedOption = option;
    }
    qs[currentPageIndex].question.isButtonPressable = true;
    setState(() {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchMultiQuestions() async {
    try {
      final questions =
          await MultiQuestionService.fetchQuestionsByLevel(widget.level);

      _MultiQuestions = questions;

      fillMultiQList(_MultiQuestions);
    } catch (e) {
      print('Error fetching questions: $e');
    }
  }

  Future<void> _fetchMatchQuestions() async {
    try {
      final matchQuestions =
          await MatchQuestionService.fetchQuestionsByLevel(widget.level);

      _MatchQuestions = matchQuestions;

      fillMatchQList(_MatchQuestions);
    } catch (e) {
      print('Error fetching questions: $e');
    }
  }

  fillMultiQList(List<MultiQuestion> _multiQuestions) {
    _MultiQuestions.forEach((element) {
      _MultiQuestionsViews.add(Multi_q_view(
        updateChoice: updateChoice,
        question: element,
      ));
    });

    qs.addAll(_MultiQuestionsViews.toList());
  }

  fillMatchQList(List<MatchQuestion> _matchQuestions) {
    _MatchQuestions.forEach((element) {
      _MatchQuestionsViews.add(MatchQView(
        updateChoice: updateChoice,
        question: element,
      ));
    });

    qs.addAll(_MatchQuestionsViews);
  }

  // List of wrong answers to show at the end
  List<dynamic> wrongAnswers = [];

  void checkAnswer(BuildContext context) {
    // check result
    String result;
    String correctAnswerText = "";

    if (qs[currentPageIndex].runtimeType == Multi_q_view) {
      result = qs[currentPageIndex].question.selectedOption ==
              qs[currentPageIndex].question.rightAnswer
          ? '!إجابة صحيحة'
          : 'إجابة خاطئة';
      correctAnswerText = qs[currentPageIndex].question.selectedOption !=
              qs[currentPageIndex].question.rightAnswer
          ? ':الإجابة الصحيحة هي'
          : '';
      if (result == 'إجابة خاطئة') {
        printError(info: qs[currentPageIndex].question.selectedOption);
        qs[currentPageIndex].question.isButtonPressable = false;
        qs[currentPageIndex].question.selectedOption = "";

        wrongAnswers.add(qs[currentPageIndex]);
      }
    } else {
      result = '!إجابة صحيحة';
    }

    AudioPlayer().play(
      position: const Duration(milliseconds: 300),
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
                        qs[currentPageIndex].question.rightAnswer!,
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
                    if (currentPageIndex < qs.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    } else {
                      if (wrongAnswers.length > 0) {
                        Get.toNamed(
                          '/correctMistakes',
                          arguments: {
                            'wrongAnswers': wrongAnswers,
                            'quizLength': qs.length
                          },
                        );
                      } else {
                        Get.offAndToNamed(
                          '/score',
                          arguments: {
                            'quizLength': qs.length,
                            'wrongLength': wrongAnswers.length
                          },
                        );
                      }
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
    return qs.isEmpty
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
            title: 'سؤال ${currentPageIndex + 1} من ${qs.length}',
            body: Column(children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.864,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: qs.length,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    printInfo(info: "${qs[currentPageIndex].runtimeType}");
                    setState(() {
                      currentPageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.724,
                            child: qs[index]),
                        InkWell(
                          onTap: () {
                            qs[currentPageIndex].question.isButtonPressable
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
                                  image: qs[currentPageIndex]
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
