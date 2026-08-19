// =====================================================
// 앱 이름: 005_exdateApp_냉장고삐삐
// main.dart
// =====================================================
import 'package:flutter/material.dart';
import 'app/app.dart';

// Future 나중에 결과를 줄게
Future<void> main() async {
  // 플러터가 완전히 준비될 때까지 기다리는 코드
  WidgetsFlutterBinding.ensureInitialized();
  // runApp 플러터 앱의 시작점 -> Appdart 시작 -> lib/app/app.dart
  runApp(const Appdart());
}