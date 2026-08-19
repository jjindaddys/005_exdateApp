import 'package:exdateapp/pages/food/food_form_page.dart';
import 'package:flutter/material.dart';

import '../food/food_page.dart';
import '../home/home_page.dart';
import '../settings/settings_page.dart';
import '../shopping/shopping_page.dart';
import '../../common/widgets/banner_ad_area.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() =>
      _MainNavigationPageState();
}

class _MainNavigationPageState
    extends State<MainNavigationPage> {
  int selectedIndex = 1;

  // 화면 별 Widget
  final List<Widget> pages = const [
    HomePage(),
    FoodPage(),
    ShoppingPage(),
    SettingsPage(),
  ];

  // 화면 별 Widget Title
  final List<String> pageTitles = const [
    '우리집 냉장고',
    '식품',
    '장보기',
    '설정',
  ];
  
  void openNotifications() {
    // 추후 알림 화면으로 이동
  }

  void openMembers() {
    // 추후 냉장고 구성원 화면으로 이동
  }
  void changePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget? buildFloatingActionButton() {
    if(selectedIndex == 1) {
      // FloatingActionButton.Extended사용해야 문구를 넣을 수 있음 Icon넣으려면 extended제거
      return FloatingActionButton.extended(
        onPressed: () async {
          final FoodFormResult? result = await Navigator.push<FoodFormResult>(
            context, 
            MaterialPageRoute(
              builder: (context){
                return const FoodFormPage();
              })
          );  
          if (result == null) {
            return;
          }
        },
        label: const Text('식품 등록하기'),
      );
      
    }
    if (selectedIndex == 2) {
      return FloatingActionButton.extended
      (
        onPressed: (){
          // 추후 장보기 등록 화면으로
        },
        label: const Text('장보기 등록하기'),
        );
    }

    return null;
  }
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 배너 광고와 안전영역은 바깥 Scaffold가 담당
      bottomNavigationBar: const BannerAdArea(),

      // 안쪽 Scaffold에서는 하단 안전영역을 제거
      body: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text(pageTitles[selectedIndex]),
            actions: [
              IconButton(
                onPressed: openNotifications,
                icon: const Icon(Icons.notifications_outlined),
                tooltip: '알림',
              ),
              IconButton(
                onPressed: openMembers,
                icon: const Icon(Icons.group_outlined),
                tooltip: '구성원',
              ),
            ],
          ),
          body: IndexedStack(
            index: selectedIndex,
            children: pages,
          ),
          floatingActionButton: buildFloatingActionButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: changePage,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: '홈',
              ),
              NavigationDestination(
                icon: Icon(Icons.kitchen_outlined),
                selectedIcon: Icon(Icons.kitchen),
                label: '식품',
              ),
              NavigationDestination(
                icon: Icon(Icons.shopping_cart_outlined),
                selectedIcon: Icon(Icons.shopping_cart),
                label: '장보기',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: '설정',
              ),
            ],
          ),
        ),
      ),
    );
  }
}