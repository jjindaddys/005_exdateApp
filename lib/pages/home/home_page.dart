import 'package:flutter/material.dart';

import '../../common/layouts/common_page_layout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CommonPageLayout(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('홈 화면'),
          ],
        ),
      ),
    );
  }
}