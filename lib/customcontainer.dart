import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Color color;
  final String headerText;
  final String descText;
  const CustomContainer({
    super.key,
    required this.color,
    required this.headerText,
    required this.descText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(11),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
        ).copyWith(
          left: 15,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                headerText,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 2.5,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                descText,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
