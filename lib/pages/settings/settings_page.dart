import 'package:flutter/material.dart';

import '../../common/layouts/common_page_layout.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CommonPageLayout(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('설정 화면'),
          ],
        ),
      ),
    );
  }
}