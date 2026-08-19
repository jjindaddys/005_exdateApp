// Common_page_layout 공통 화면 틀
import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';

class CommonPageLayout extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double maxWidth;
  final Color? backgroundColor;

  const CommonPageLayout({
    super.key,
    required this.child,
    this.padding,
    this.maxWidth = 600,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // ColoredBox 전체 영역에 배경색 적용
    return ColoredBox(
      color: backgroundColor ??
          Theme.of(context).scaffoldBackgroundColor,
          // SafdArea 휴대폰의 시스템 영역과 겹치지 않게 해줌 (상단의 카메라 영역, 하단의 시스템 영역)
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxWidth,
                ),
                child: Padding(
                  padding: padding ??
                    const EdgeInsets.fromLTRB(
                      AppSizes.padding,      // 왼쪽 16
                      AppSizes.padding,      // 위쪽 16
                      AppSizes.padding,      // 오른쪽 16
                      AppSizes.largePadding, // 아래쪽 24
                    ),
                    child: child,
            ),
          ),
        )
      ),
    );
  }
}