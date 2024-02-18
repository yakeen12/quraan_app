import 'package:quraan/models/multi_q_model.dart';
import 'package:quraan/services/multi_q_services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:quraan/resources/images.dart';
import 'package:quraan/utils/colors.dart';
import 'package:quraan/widgets/m_q_button.dart';

class Multi_q extends StatefulWidget {
  final int level;
  const Multi_q({required this.level});

  @override
  State<Multi_q> createState() => _Multi_qState();
}

class _Multi_qState extends State<Multi_q> {
  List<MultiQuestion> _questions = [];

  @override
  void initState() {
    super.initState();
    print("level : ${widget.level}");
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    try {
      final questions =
          await MultiQuestionService.fetchQuestionsByLevel(widget.level);
      setState(() {
        _questions = questions;
      });
    } catch (e) {
      print('Error fetching questions: $e');
    }

    // final questions = await MultiQuestionService.fetchQuestionsByLevel(2);
    // setState(() {
    //   _questions = questions;
    // });
  }

  String selectedOption = '';
  String result = '';
  bool isButtonPressable = false;

  void setSelectedOption(String option) {
    setState(() {
      selectedOption = option;
      isButtonPressable = true;
    });
  }

  void checkAnswer(BuildContext context) {
    // check result
    String result = selectedOption == _questions[1].rightAnswer
        ? '!إجابة صحيحة'
        : 'إجابة خاطئة';
    String correctAnswerText = selectedOption != _questions[1].rightAnswer
        ? ':الإجابة الصحيحة هي'
        : '';

    AudioPlayer().play(
        AssetSource(result == '!إجابة صحيحة' ? 'correct.mp3' : 'wrong.mp3'));

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
                        _questions[1].rightAnswer!,
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
                    Navigator.pop(context);
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
    return _questions.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              title: const GlowText(
                'سؤال تجريبي',
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
                                image: AssetImage(metalGreen),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GlowText(
                                  _questions[1].question!,
                                  textDirection: TextDirection.rtl,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: (primaryColor1),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      ...List.generate(
                        4,
                        growable: true,
                        (index) => ChoiceButton(
                          option: _questions[1].choices![index],
                          isSelected:
                              selectedOption == _questions[1].choices![index],
                          onPressed: () =>
                              setSelectedOption(_questions[1].choices![index]),
                        ),
                      ),
                      InkWell(
                        onTap: selectedOption.isEmpty
                            ? null
                            : () => checkAnswer(context),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          height: MediaQuery.of(context).size.height * 0.13,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.transparent,
                          ),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: isButtonPressable
                                    ? AssetImage(metalGreen)
                                    : AssetImage(nullColor),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
