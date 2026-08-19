import 'package:flutter/material.dart';
import '../constants/app_breakpoints.dart';

// extension를 사용하면 BuildContext에다가 기능을 추가할 수 있다
extension ContextExtension on BuildContext {

  // 화면 전체 가로 길이
  double get screenWidth {
    return MediaQuery.sizeOf(this).width;
  }
  // 화면 전체 세로 길이
  double get screenHeight {
    return MediaQuery.sizeOf(this).height;
  }
  // 시스템 상단 상태바 높이
  double get statusBarHeight {
    return MediaQuery.paddingOf(this).top;
  }
  // 시스템 하단 안전 영역 높이
  double get bottomSafeAre {
    return MediaQuery.paddingOf(this).bottom;
  }
  /// 작은 휴대폰인지 확인
  bool get isSmallPhone {
    return screenWidth < AppBreakpoints.smallPhone;
  }
  /// 일반 휴대폰인지 확인
  bool get isPhone {
    return screenWidth < AppBreakpoints.phone;
  }
  /// 태블릿인지 확인
  bool get isTablet {
    return screenWidth >= AppBreakpoints.phone &&
        screenWidth < AppBreakpoints.tablet;
  }
  /// 큰 화면인지 확인
  bool get isLargeScreen {
    return screenWidth >= AppBreakpoints.tablet;
  }
}