import 'package:quraan/models/multi_q_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:quraan/resources/images.dart';
import 'package:quraan/utils/colors.dart';
import 'package:quraan/widgets/CustomRadioButton.dart';

class Multi_q_view extends StatefulWidget {
  final MultiQuestion question;
  final Function(String) updateChoice;

  const Multi_q_view({required this.question, required this.updateChoice});

  @override
  State<Multi_q_view> createState() => _Multi_q_viewState();
}

class _Multi_q_viewState extends State<Multi_q_view> {
  late MultiQuestion _question;

  @override
  void initState() {
    super.initState();
    _question = widget.question;
  }

  String result = '';

  void setSelectedOption(String option) {
    setState(() {
      _question.selectedOption = option;
      widget.updateChoice(option);
    });
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
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GlowText(
                            _question.question!,
                            textDirection: TextDirection.rtl,
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
                ...List.generate(
                  4,
                  growable: true,
                  (index) => ChoiceButton(
                    option: _question.choices![index],
                    isSelected:
                        _question.selectedOption == _question.choices![index],
                    onPressed: () =>
                        setSelectedOption(_question.choices![index]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
