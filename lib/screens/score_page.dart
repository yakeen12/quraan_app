import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quraan/resources/images.dart';
import 'package:quraan/utils/colors.dart';
import 'package:quraan/widgets/CustomRadioButton.dart';

class ScorePage extends StatelessWidget {
  final int quizLength;
  final int wrongLength;
  const ScorePage(
      {super.key, required this.quizLength, required this.wrongLength});

  int getScore() {
    int score = quizLength - wrongLength;
    return score;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image:
                DecorationImage(image: AssetImage(goldBg), fit: BoxFit.fill)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                "نتيجتك هي ${getScore()} من $quizLength",
                style: const TextStyle(
                    color: primaryColor2,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              AutoSizeText(
                statementByScore(quizLength, getScore()),
                style: TextStyle(
                    color: primaryColor2,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: ChoiceButton(
                  isSelected: false,
                  onPressed: () => Get.offAllNamed('/home'),
                  option: "العودة إلى صفحة البداية",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String statementByScore(int quizLength, int correctAnswersCount) {
// Calculate the user's score as a percentage
    double userScore = (correctAnswersCount / quizLength) * 100;

// Check if the user's score is greater than 90%
    if (userScore > 90) {
      return 'نتيجة رائعة!';
    }
// Check if the user's score is greater than 80%
    else if (userScore > 80) {
      return 'أحسنت بارك الله فيك';
    }
    //
    else if (userScore > 70) {
      return "جهودك مباركة";
    }
// Handle other cases
    else {
      return 'انت بحاجة الى المذاكرة';
    }
  }
}
