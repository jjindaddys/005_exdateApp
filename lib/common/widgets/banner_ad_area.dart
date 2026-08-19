import 'package:flutter/material.dart';

class BannerAdArea extends StatelessWidget {
  const BannerAdArea({super.key});

  static const double bannerHeight = 50;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade200,
      child: SafeArea(
        top: false,
        child: const SizedBox(
          height: bannerHeight,
          child: Center(
            child: Text(
              '배너 광고 영역',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}