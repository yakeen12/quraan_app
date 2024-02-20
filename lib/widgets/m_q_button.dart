import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:quraan/resources/images.dart';
import 'package:quraan/utils/colors.dart';

class ChoiceButton extends StatelessWidget {
  final String option;
  final bool isSelected;
  final VoidCallback onPressed;

  const ChoiceButton({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        height: MediaQuery.of(context).size.height * 0.09,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.green.shade400,
        ),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
                opacity: isSelected ? 0.7 : 1,
                // colorFilter: (selected?? ColorFilter.),
                image: const AssetImage(metalGreen),
                fit: BoxFit.cover),
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
                  option,
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
    );
  }
}
