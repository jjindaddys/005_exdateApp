// app_theme.dart 테마 관리
import 'package:flutter/material.dart';
import '../common/constants/app_colors.dart';
// AppTheme 테마를 관리하는 클래스 AppTheme.lightTheme로 사용가능
class AppTheme {
  // 객체를 만들 필요가 없기 때문에 AppTheme._() 프라이빗 생성자
  AppTheme._();

  // static 매번 새로 만들지 않기 위함 메모리에 하나만 올려서 어디서든 공유
  // ThemeData 전체 디자인 영역 -> 플러터 프레임워크가 제공하는 앱의 전체적인 테마 스타일 정보를 담는 클래스 타입
  // lightTheme 직접 내가 지정한 이름
  static ThemeData get lightTheme {
    return ThemeData(
      // 플러터 최신 디자인
      useMaterial3: true,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary
        ),
        // 앱 전체 배경색
        scaffoldBackgroundColor: AppColors.background,
        // appBar Theme
        appBarTheme: const AppBarTheme(
          // 문자 센터
          centerTitle: true,
          // 그림자
          elevation: 0,
          // 배경색
          backgroundColor: AppColors.background,
          // 글자색
          foregroundColor: AppColors.textPrimary,
        ),
    );
  }
}