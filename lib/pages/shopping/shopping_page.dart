import 'package:flutter/material.dart';

import '../../common/layouts/common_page_layout.dart';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonPageLayout(
      child: ListView(
        children: const [
          Text('장보기 화면'),
        ],
      ),
    );
  }
}