import 'package:flutter/material.dart';

class SettingCard extends StatelessWidget {
  final String title;
  final String image;
  final double width;
  final double height;
  final VoidCallback onTap;
  const SettingCard({
    super.key,
    required this.title,
    required this.image,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: const Border.fromBorderSide(
              BorderSide(
                color: Colors.blue,
                width: 2,
              ),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                image,
                width: width,
                height: height,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.fade,
                textAlign: TextAlign.center,
              ),
            ],
          )),
    );
  }
}
