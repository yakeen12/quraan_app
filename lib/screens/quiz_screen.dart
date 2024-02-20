import 'package:get/get.dart';
import 'package:quraan/models/multi_q_model.dart';
import 'package:quraan/services/multi_q_services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:quraan/resources/images.dart';
import 'package:quraan/utils/colors.dart';
import 'package:quraan/views/multi_q_view.dart';
import 'package:quraan/widgets/m_q_button.dart';

class QuizPage extends StatefulWidget {
  final int level;
  const QuizPage({required this.level});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late PageController _pageController;
  int currentPageIndex = 0;
  int score = 0;

  List<MultiQuestion> _MultiQuestions = [];

  List<Multi_q_view> _MultiQuestionsViews = [];
  @override
  void initState() {
    super.initState();
    print("level : ${widget.level}");
    _fetchMultiQuestions();
    _pageController = PageController();
  }

  void updateChoice(String option) {
    _MultiQuestions[currentPageIndex].selectedOption = option;
    _MultiQuestions[currentPageIndex].isButtonPressable = true;
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
      setState(() {
        _MultiQuestions = questions;
      });

      fillMultiQList(_MultiQuestions);
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
  }

  void checkAnswer(BuildContext context) {
    // check result
    String result = _MultiQuestions[currentPageIndex].selectedOption ==
            _MultiQuestions[currentPageIndex].rightAnswer
        ? '!إجابة صحيحة'
        : 'إجابة خاطئة';

    printError(info: _MultiQuestions[currentPageIndex].selectedOption);
    String correctAnswerText =
        _MultiQuestions[currentPageIndex].selectedOption !=
                _MultiQuestions[currentPageIndex].rightAnswer
            ? ':الإجابة الصحيحة هي'
            : '';

    AudioPlayer().play(
      position: Duration(milliseconds: 350),
      AssetSource(
        result == '!إجابة صحيحة' ? 'correct.mp3' : 'wrong.mp3',
      ),
    );

    // show modal
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Color.fromARGB(205, 0, 0, 0),
          padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
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
                  SizedBox(
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
              SizedBox(height: 10),
              if (correctAnswerText.isNotEmpty)
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        correctAnswerText,
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        _MultiQuestions[currentPageIndex].rightAnswer!,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    if (currentPageIndex < _MultiQuestions.length - 1) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    primary:
                        result == '!إجابة صحيحة' ? Colors.green : Colors.red,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    // style: ElevatedButton.styleFrom(
                    //   elevation: 0,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(8.0),
                    //     side: BorderSide(
                    //         color: result == '!إجابة صحيحة'
                    //             ? Colors.green
                    //             : Colors.red),
                    //   ),
                  ),
                  child: Text(
                    correctAnswerText.isNotEmpty ? 'فهمت' : 'أكمل',
                    style: TextStyle(
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
    return _MultiQuestions.isEmpty
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              title: GlowText(
                'سؤال ${currentPageIndex + 1} من ${_MultiQuestions.length}',
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
                  child: Column(children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.864,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _MultiQuestionsViews.length,
                        physics: NeverScrollableScrollPhysics(),
                        onPageChanged: (index) {
                          setState(() {
                            currentPageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.724,
                                  child: _MultiQuestionsViews[index]),
                              InkWell(
                                onTap: _MultiQuestions[currentPageIndex]
                                        .selectedOption
                                        .isEmpty
                                    ? null
                                    : () => checkAnswer(context),
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.transparent,
                                  ),
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: _MultiQuestions[currentPageIndex]
                                                .isButtonPressable
                                            ? AssetImage(metalGreen)
                                            : AssetImage(nullColor),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GlowText(
                                            "تحقق",
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
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.pop(context);
                    //       if (currentPageIndex < _MultiQuestions.length - 1) {
                    //         _pageController.nextPage(
                    //           duration: Duration(milliseconds: 500),
                    //           curve: Curves.ease,
                    //         );
                    //       }
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       padding: EdgeInsets.symmetric(vertical: 14.0),
                    //       primary: Colors.green,
                    //       elevation: 0,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(8.0),
                    //       ),
                    //     ),
                    //     child: Text(
                    //       'أكمل',
                    //       style: TextStyle(
                    //           color: Colors.black,
                    //           fontSize: 20,
                    //           fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    // ),
                  ]),

                  // floatingActionButton: FloatingActionButton(
                  //   onPressed: () {
                  //     if (currentPageIndex < widget.questions.length - 1) {
                  //       _pageController.nextPage(
                  //         duration: Duration(milliseconds: 500),
                  //         curve: Curves.ease,
                  //       );
                  //     }
                  //   },
                  //   child: Icon(Icons.arrow_forward),
                  // ), // here we add the q object
                ),
              ),
            ),
          );
  }
}
