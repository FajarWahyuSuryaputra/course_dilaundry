import 'package:course_dilaundry/config/app_assets.dart';
import 'package:flutter/material.dart';

class ErrorBackground extends StatelessWidget {
  const ErrorBackground(
      {super.key, required this.ratio, required this.message});
  final double ratio;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: ratio,
      child: Stack(fit: StackFit.expand, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            AppAssets.emptyBG,
            fit: BoxFit.cover,
          ),
        ),
        UnconstrainedBox(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Text(
              message,
              style:
                  const TextStyle(color: Colors.grey, fontSize: 16, height: 1),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ]),
    );
  }
}
