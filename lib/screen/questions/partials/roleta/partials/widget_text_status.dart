import 'package:flutter/material.dart';

class WidgetTextStatus extends StatelessWidget {
  final List<String> text;
  final String pathImage;
  const WidgetTextStatus({
    super.key,
    required this.text,
    required this.pathImage,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(pathImage, height: height * 0.3, width: width * 0.4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < text.length; i++) ...[
                if (i > 0) const SizedBox(height: 10),
                Text(
                  text[i],
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
