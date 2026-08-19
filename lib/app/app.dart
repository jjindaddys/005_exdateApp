// app.dart 기본 설정
// =====================================================
// 앱 이름
// 테마
// 글자 크기 제한
// 시작 화면
// 화면 이동
// 업데이트 확인
// =====================================================
import 'package:flutter/material.dart';
import 'app_theme.dart';
import '../pages/main/main_navigation_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Appdart: StatelessWidget 내부 상태가 바뀌지 않는 위젯
class Appdart extends StatelessWidget {
  // 생성자
  const Appdart({super.key});

  // build 화면에 무엇을 그릴지 반환하는 함수
  @override
  Widget build(BuildContext context) {
    // MaterialApp 플러터 앱의 가장 바깥쪽 위젯
    return MaterialApp(
      // 앱에서 사용할 언어
      locale: const Locale('ko', 'KR'),

      // 앱에서 지원하는 언어
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        final MediaQueryData mediaQuery =
            MediaQuery.of(context);

        return MediaQuery(
            data: mediaQuery.copyWith(
              textScaler: mediaQuery.textScaler.clamp(
                minScaleFactor: 1.0,
                maxScaleFactor: 1.4,
              ),
            ),
          child: child!,
        );
      },
      // 디버그 표시 제거
      debugShowCheckedModeBanner: false,
      // 운영체제가 앱을 식별할 때 사용하는 제목
      title: '우리집 냉장고',
      theme: AppTheme.lightTheme,
      // 앱을 실행했을 때 처음 표시할 화면 Scaffold 화면의 기본 뼈대 제공
      home: MainNavigationPage()
    );
  }
}