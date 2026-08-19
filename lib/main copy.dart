import 'package:flutter/material.dart';

void main() {
  runApp(const RefrigeratorApp());
}

class RefrigeratorApp extends StatelessWidget {
  const RefrigeratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '우리집 냉장고',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F8FA),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Color(0xFF101828),
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      home: const MainNavigationPage(),
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() {
    return _MainNavigationPageState();
  }
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int selectedIndex = 1;

  final List<Widget> pages = const [
    HomePage(),
    FoodPage(),
    ShoppingPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: '홈',
          ),
          NavigationDestination(
            icon: Icon(Icons.kitchen_outlined),
            selectedIcon: Icon(Icons.kitchen_rounded),
            label: '식품',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart_rounded),
            label: '장보기',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: '설정',
          ),
        ],
      ),
    );
  }
}

/* =========================================================
   홈 화면
========================================================= */

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('우리집 냉장고'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.group_outlined,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          16,
          12,
          16,
          24,
        ),
        children: const [
          DashboardCard(
            title: '곧 기한이 끝나요',
            description: '유통기한이 얼마 남지 않은 식품을 확인해 보세요.',
            icon: Icons.schedule_rounded,
            iconBackgroundColor: Color(0xFFFFECE8),
            iconColor: Color(0xFFD92D20),
          ),
          SizedBox(height: 12),
          DashboardCard(
            title: '최근 활동',
            description: '가족이 최근 등록하거나 수정한 내용을 확인해 보세요.',
            icon: Icons.history_rounded,
            iconBackgroundColor: Color(0xFFEAF4FF),
            iconColor: Color(0xFF2563EB),
          ),
          SizedBox(height: 12),
          DashboardCard(
            title: '장보기 요청',
            description: '가족이 요청한 장보기 항목을 확인해 보세요.',
            icon: Icons.shopping_bag_outlined,
            iconBackgroundColor: Color(0xFFF0ECFF),
            iconColor: Color(0xFF6941C6),
          ),
          SizedBox(height: 12),
          DashboardCard(
            title: '보관 현황',
            description: '냉장·냉동·실온 식품의 보관 현황을 확인해 보세요.',
            icon: Icons.inventory_2_outlined,
            iconBackgroundColor: Color(0xFFE7F8F2),
            iconColor: Color(0xFF027A48),
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;

  const DashboardCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFEAECF0),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A101828),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF101828),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Color(0xFF667085),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFF98A2B3),
          ),
        ],
      ),
    );
  }
}

/* =========================================================
   식품 화면
========================================================= */

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() {
    return _FoodPageState();
  }
}

class _FoodPageState extends State<FoodPage> {
  final TextEditingController searchController =
      TextEditingController();

  int selectedStorageIndex = 0;

  String searchKeyword = '';

  FoodSortType sortType = FoodSortType.expirationSoon;


String get currentTitle {
  switch (selectedStorageIndex) {
    case 1:
      return '냉장 식품';
    case 2:
      return '냉동 식품';
    case 3:
      return '실온 식품';
    default:
      return '전체 식품';
  }
}

  final List<FoodItem> foods = [
    FoodItem(
      id: 1,
      name: '양파',
      storageType: StorageType.roomTemperature,
      expirationDate: DateTime.now().add(
        const Duration(days: 3),
      ),
      quantity: 3,
      unit: '개',
      memo: '볶음밥 만들 때 사용',
    ),
    FoodItem(
      id: 2,
      name: '삼겹살',
      storageType: StorageType.frozen,
      expirationDate: DateTime.now().add(
        const Duration(days: 7),
      ),
      quantity: 1,
      unit: '팩',
      memo: '주말 저녁용',
    ),
    FoodItem(
      id: 3,
      name: '우유',
      storageType: StorageType.refrigerated,
      expirationDate: DateTime.now().add(
        const Duration(days: 1),
      ),
      quantity: 2,
      unit: '개',
      memo: '',
    ),
    FoodItem(
      id: 4,
      name: '계란',
      storageType: StorageType.refrigerated,
      expirationDate: DateTime.now().add(
        const Duration(days: 10),
      ),
      quantity: 10,
      unit: '개',
      memo: '',
    ),
    FoodItem(
      id: 5,
      name: '냉동 만두',
      storageType: StorageType.frozen,
      expirationDate: DateTime.now().add(
        const Duration(days: 24),
      ),
      quantity: 2,
      unit: '봉',
      memo: '',
    ),
    FoodItem(
      id: 6,
      name: '감자',
      storageType: StorageType.roomTemperature,
      expirationDate: DateTime.now().subtract(
        const Duration(days: 1),
      ),
      quantity: 4,
      unit: '개',
      memo: '상태 확인 필요',
    ),
  ];

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      setState(() {
        searchKeyword =
            searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<FoodItem> get filteredFoods {
    List<FoodItem> result = [...foods];

    if (selectedStorageIndex == 1) {
      result = result.where((food) {
        return food.storageType ==
            StorageType.refrigerated;
      }).toList();
    }

    if (selectedStorageIndex == 2) {
      result = result.where((food) {
        return food.storageType ==
            StorageType.frozen;
      }).toList();
    }

    if (selectedStorageIndex == 3) {
      result = result.where((food) {
        return food.storageType ==
            StorageType.roomTemperature;
      }).toList();
    }

    if (searchKeyword.isNotEmpty) {
      result = result.where((food) {
        return food.name
            .toLowerCase()
            .contains(searchKeyword);
      }).toList();
    }

    switch (sortType) {
      case FoodSortType.expirationSoon:
        result.sort((a, b) {
          return a.expirationDate.compareTo(
            b.expirationDate,
          );
        });
        break;

      case FoodSortType.recentlyRegistered:
        result.sort((a, b) {
          return b.id.compareTo(a.id);
        });
        break;

      case FoodSortType.name:
        result.sort((a, b) {
          return a.name.compareTo(b.name);
        });
        break;

      case FoodSortType.quantity:
        result.sort((a, b) {
          return b.quantity.compareTo(a.quantity);
        });
        break;
    }

    return result;
  }

  void increaseQuantity(FoodItem food) {
    setState(() {
      food.quantity++;
    });
  }

  void decreaseQuantity(FoodItem food) {
    if (food.quantity <= 0) {
      return;
    }

    setState(() {
      food.quantity--;
    });
  }

  Future<void> confirmDeleteFood(
    FoodItem food,
  ) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            '식품을 삭제할까요?',
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Text(
            '${food.name}을(를) 식품 목록에서 삭제합니다.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('취소'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor:
                    const Color(0xFFD92D20),
              ),
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );

    if (result != true) {
      return;
    }

    setState(() {
      foods.removeWhere((item) {
        return item.id == food.id;
      });
    });

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${food.name}을(를) 삭제했어요.',
        ),
      ),
    );
  }

  void showFoodDetail(FoodItem food) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            MediaQuery.of(bottomSheetContext)
                    .padding
                    .bottom +
                24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFD0D5DD),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      food.name,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF101828),
                      ),
                    ),
                  ),
                  DDayBadge(
                    text: getDDayText(
                      food.expirationDate,
                    ),
                    color: getDDayColor(
                      food.expirationDate,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              DetailRow(
                title: '보관 방식',
                value: food.storageType.label,
              ),
              DetailRow(
                title: '유통기한',
                value: formatDate(
                  food.expirationDate,
                ),
              ),
              DetailRow(
                title: '수량',
                value:
                    '${food.quantity}${food.unit}',
              ),
              DetailRow(
                title: '메모',
                value: food.memo.isEmpty
                    ? '등록된 메모가 없습니다.'
                    : food.memo,
                showDivider: false,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(
                      bottomSheetContext,
                    );
                  },
                  child: const Text(
                    '확인',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showSortSheet() async {
    final FoodSortType? result =
        await showModalBottomSheet<FoodSortType>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            MediaQuery.of(bottomSheetContext)
                    .padding
                    .bottom +
                20,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color:
                        const Color(0xFFD0D5DD),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                '정렬',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              SortTile(
                title: '유통기한 임박순',
                value: FoodSortType.expirationSoon,
                selectedValue: sortType,
              ),
              SortTile(
                title: '최근 등록순',
                value:
                    FoodSortType.recentlyRegistered,
                selectedValue: sortType,
              ),
              SortTile(
                title: '이름순',
                value: FoodSortType.name,
                selectedValue: sortType,
              ),
              SortTile(
                title: '수량 많은 순',
                value: FoodSortType.quantity,
                selectedValue: sortType,
              ),
            ],
          ),
        );
      },
    );

    if (result == null) {
      return;
    }

    setState(() {
      sortType = result;
    });
  }

  Future<void> showAddFoodSheet() async {
    final FoodItem? newFood =
        await showModalBottomSheet<FoodItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return const AddFoodSheet();
      },
    );

    if (newFood == null) {
      return;
    }

    int nextId = 1;

    if (foods.isNotEmpty) {
      nextId = foods
              .map((food) => food.id)
              .reduce((a, b) {
            return a > b ? a : b;
          }) +
          1;
    }

    setState(() {
      foods.add(
        FoodItem(
          id: nextId,
          name: newFood.name,
          storageType: newFood.storageType,
          expirationDate:
              newFood.expirationDate,
          quantity: newFood.quantity,
          unit: newFood.unit,
          memo: newFood.memo,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<FoodItem> items = filteredFoods;

    return Scaffold(
      appBar: AppBar(
        title: const Text('식품'),
        actions: [
          IconButton(
            tooltip: '정렬',
            onPressed: showSortSheet,
            icon: const Icon(
              Icons.swap_vert_rounded,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: showAddFoodSheet,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          '식품 추가',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            /*
             * 전체 / 냉장 / 냉동 / 실온 탭
             */
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: StorageTabButton(
                      title: '전체',
                      selected:
                          selectedStorageIndex == 0,
                      backgroundColor: Colors.white,
                      borderColor:
                          const Color(0xFFD0D5DD),
                      foregroundColor:
                          const Color(0xFF344054),
                      onTap: () {
                        setState(() {
                          selectedStorageIndex = 0;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: StorageTabButton(
                      title: '냉장',
                      selected:
                          selectedStorageIndex == 1,
                      backgroundColor:
                          StorageType.refrigerated
                              .backgroundColor,
                      borderColor:
                          StorageType.refrigerated
                              .borderColor,
                      foregroundColor:
                          StorageType.refrigerated
                              .foregroundColor,
                      onTap: () {
                        setState(() {
                          selectedStorageIndex = 1;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: StorageTabButton(
                      title: '냉동',
                      selected:
                          selectedStorageIndex == 2,
                      backgroundColor:
                          StorageType.frozen
                              .backgroundColor,
                      borderColor:
                          StorageType.frozen
                              .borderColor,
                      foregroundColor:
                          StorageType.frozen
                              .foregroundColor,
                      onTap: () {
                        setState(() {
                          selectedStorageIndex = 2;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: StorageTabButton(
                      title: '실온',
                      selected:
                          selectedStorageIndex == 3,
                      backgroundColor:
                          StorageType.roomTemperature
                              .backgroundColor,
                      borderColor:
                          StorageType.roomTemperature
                              .borderColor,
                      foregroundColor:
                          StorageType.roomTemperature
                              .foregroundColor,
                      onTap: () {
                        setState(() {
                          selectedStorageIndex = 3;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            /*
             * 검색창
             */
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                14,
                16,
                14,
              ),
              child: TextField(
                controller: searchController,
                textInputAction:
                    TextInputAction.search,
                decoration: InputDecoration(
                  hintText: '식품 이름을 검색하세요',
                  hintStyle: const TextStyle(
                    color: Color(0xFF98A2B3),
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                  ),
                  suffixIcon:
                      searchController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                searchController.clear();
                              },
                              icon: const Icon(
                                Icons.close_rounded,
                              ),
                            ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFFEAECF0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFF84CAFF),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
  padding: const EdgeInsets.fromLTRB(18, 4, 18, 14),
  child: Row(
    children: [
      Text(
        currentTitle,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
      const Spacer(),
      InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: showSortSheet,
        child: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          child: Row(
            children: [
              Icon(
                Icons.swap_vert_rounded,
                size: 18,
                color: Color(0xFF667085),
              ),
              SizedBox(width: 4),
              Text(
                "정렬",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF667085),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
),

            Expanded(
              child: items.isEmpty
                  ? const EmptyFoodView()
                  : GridView.builder(
                      padding:
                          const EdgeInsets.fromLTRB(
                        14,
                        0,
                        14,
                        100,
                      ),
                      itemCount: items.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 11,
                        mainAxisSpacing: 11,
                        childAspectRatio: 1.02,
                      ),
                      itemBuilder:
                          (context, index) {
                        final FoodItem food =
                            items[index];

                        return FoodCard(
                          food: food,
                          dDayText: getDDayText(
                            food.expirationDate,
                          ),
                          dDayColor: getDDayColor(
                            food.expirationDate,
                          ),
                          onCardTap: () {
                            showFoodDetail(food);
                          },
                          onDecrease: () {
                            decreaseQuantity(food);
                          },
                          onIncrease: () {
                            increaseQuantity(food);
                          },
                          onDelete: () {
                            confirmDeleteFood(food);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/* =========================================================
   상단 보관 방식 탭
========================================================= */

class StorageTabButton extends StatelessWidget {
  final String title;
  final bool selected;
  final Color backgroundColor;
  final Color borderColor;
  final Color foregroundColor;
  final VoidCallback onTap;

  const StorageTabButton({
    super.key,
    required this.title,
    required this.selected,
    required this.backgroundColor,
    required this.borderColor,
    required this.foregroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 180,
          ),
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: selected
                  ? foregroundColor
                  : borderColor,
              width: selected ? 2 : 1,
            ),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0x0F101828),
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Text(
            title,
            style: TextStyle(
              color: foregroundColor,
              fontSize: 14,
              fontWeight: selected
                  ? FontWeight.w900
                  : FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

/* =========================================================
   식품 카드
========================================================= */

class FoodCard extends StatelessWidget {
  final FoodItem food;
  final String dDayText;
  final Color dDayColor;
  final VoidCallback onCardTap;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onDelete;

  const FoodCard({
    super.key,
    required this.food,
    required this.dDayText,
    required this.dDayColor,
    required this.onCardTap,
    required this.onDecrease,
    required this.onIncrease,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: food.storageType.backgroundColor,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onCardTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            15,
            14,
            12,
            13,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: food.storageType.borderColor,
              width: 1.2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x09101828),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              /*
               * 식품 이름 / D-Day
               */
              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      food.name,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.1,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF101828),
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  DDayBadge(
                    text: dDayText,
                    color: dDayColor,
                  ),
                ],
              ),

              /*
               * D-Day 아래 유통기한 날짜
               */
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                    right: 3,
                  ),
                  child: Text(
                    formatDate(
                      food.expirationDate,
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF667085),
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              /*
               * 삭제 버튼
               */
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  tooltip: '삭제',
                  onPressed: onDelete,
                  visualDensity:
                      VisualDensity.compact,
                  constraints:
                      const BoxConstraints(
                    minWidth: 38,
                    minHeight: 38,
                  ),
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    size: 23,
                    color: Color(0xFFB42318),
                  ),
                ),
              ),

              const SizedBox(height: 2),

              /*
               * 수량 감소 / 현재 수량 / 수량 증가
               */
              Row(
                children: [
                  QuantityButton(
                    icon: Icons.remove_rounded,
                    onPressed: onDecrease,
                    enabled: food.quantity > 0,
                  ),
                  Expanded(
                    child: Text(
                      '${food.quantity}${food.unit}',
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF344054),
                      ),
                    ),
                  ),
                  QuantityButton(
                    icon: Icons.add_rounded,
                    onPressed: onIncrease,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* =========================================================
   D-Day 표시
========================================================= */

class DDayBadge extends StatelessWidget {
  final String text;
  final Color color;

  const DDayBadge({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 49,
        minHeight: 36,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.96,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: color.withValues(
            alpha: 0.22,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A101828),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        maxLines: 1,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

/* =========================================================
   수량 버튼
========================================================= */

class QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool enabled;

  const QuantityButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled
          ? Colors.white.withValues(
              alpha: 0.96,
            )
          : Colors.white.withValues(
              alpha: 0.45,
            ),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(
            icon,
            size: 22,
            color: enabled
                ? const Color(0xFF344054)
                : const Color(0xFFB8BEC9),
          ),
        ),
      ),
    );
  }
}

/* =========================================================
   식품이 없을 때
========================================================= */

class EmptyFoodView extends StatelessWidget {
  const EmptyFoodView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 78,
              height: 78,
              decoration: const BoxDecoration(
                color: Color(0xFFEAF4FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.kitchen_outlined,
                size: 38,
                color: Color(0xFF1570EF),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              '등록된 식품이 없어요',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                color: Color(0xFF101828),
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              '새로운 식품을 등록해 냉장고를 관리해 보세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF667085),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



/* =========================================================
   식품 등록 화면
========================================================= */

class AddFoodSheet extends StatefulWidget {
  const AddFoodSheet({super.key});

  @override
  State<AddFoodSheet> createState() {
    return _AddFoodSheetState();
  }
}

class _AddFoodSheetState extends State<AddFoodSheet> {
  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController quantityController =
      TextEditingController(text: '1');

  final TextEditingController unitController =
      TextEditingController(text: '개');

  final TextEditingController memoController =
      TextEditingController();

  StorageType storageType =
      StorageType.refrigerated;

  DateTime expirationDate =
      DateTime.now().add(
    const Duration(days: 7),
  );

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    unitController.dispose();
    memoController.dispose();
    super.dispose();
  }

  Future<void> selectExpirationDate() async {
    final DateTime? selectedDate =
        await showDatePicker(
      context: context,
      initialDate: expirationDate,
      firstDate: DateTime.now().subtract(
        const Duration(days: 365),
      ),
      lastDate: DateTime.now().add(
        const Duration(days: 3650),
      ),
    );

    if (selectedDate == null) {
      return;
    }

    setState(() {
      expirationDate = selectedDate;
    });
  }

  void saveFood() {
    final String name =
        nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '식품 이름을 입력해 주세요.',
          ),
        ),
      );

      return;
    }

    final int quantity =
        int.tryParse(
          quantityController.text.trim(),
        ) ??
        1;

    Navigator.pop(
      context,
      FoodItem(
        id: 0,
        name: name,
        storageType: storageType,
        expirationDate: expirationDate,
        quantity: quantity < 0 ? 0 : quantity,
        unit: unitController.text.trim().isEmpty
            ? '개'
            : unitController.text.trim(),
        memo: memoController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight:
            MediaQuery.of(context).size.height *
                0.9,
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).padding.bottom +
            20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color:
                      const Color(0xFFD0D5DD),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              '식품 추가',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 22),
            AppTextField(
              controller: nameController,
              label: '식품 이름',
              hintText: '예: 우유',
            ),
            const SizedBox(height: 16),
            const Text(
              '보관 방식',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF344054),
              ),
            ),
            const SizedBox(height: 9),
            Row(
              children: [
                Expanded(
                  child: AddStorageButton(
                    type:
                        StorageType.refrigerated,
                    selected:
                        storageType ==
                            StorageType.refrigerated,
                    onTap: () {
                      setState(() {
                        storageType =
                            StorageType.refrigerated;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AddStorageButton(
                    type: StorageType.frozen,
                    selected:
                        storageType ==
                            StorageType.frozen,
                    onTap: () {
                      setState(() {
                        storageType =
                            StorageType.frozen;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AddStorageButton(
                    type:
                        StorageType.roomTemperature,
                    selected:
                        storageType ==
                            StorageType.roomTemperature,
                    onTap: () {
                      setState(() {
                        storageType =
                            StorageType.roomTemperature;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              '유통기한',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF344054),
              ),
            ),
            const SizedBox(height: 9),
            InkWell(
              onTap: selectExpirationDate,
              borderRadius:
                  BorderRadius.circular(14),
              child: Container(
                height: 54,
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  color:
                      const Color(0xFFF9FAFB),
                  borderRadius:
                      BorderRadius.circular(14),
                  border: Border.all(
                    color:
                        const Color(0xFFD0D5DD),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                      color: Color(0xFF667085),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Text(
                        formatDate(
                          expirationDate,
                        ),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight:
                              FontWeight.w700,
                          color:
                              Color(0xFF344054),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF98A2B3),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: AppTextField(
                    controller:
                        quantityController,
                    label: '수량',
                    hintText: '1',
                    keyboardType:
                        TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppTextField(
                    controller: unitController,
                    label: '단위',
                    hintText: '개',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: memoController,
              label: '메모',
              hintText: '메모를 입력하세요',
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton(
                onPressed: saveFood,
                child: const Text(
                  '등록하기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddStorageButton extends StatelessWidget {
  final StorageType type;
  final bool selected;
  final VoidCallback onTap;

  const AddStorageButton({
    super.key,
    required this.type,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 170,
        ),
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: type.backgroundColor,
          borderRadius:
              BorderRadius.circular(13),
          border: Border.all(
            color: selected
                ? type.foregroundColor
                : type.borderColor,
            width: selected ? 2 : 1,
          ),
        ),
        child: Text(
          type.label,
          style: TextStyle(
            color: type.foregroundColor,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

/* =========================================================
   공통 입력창
========================================================= */

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final TextInputType? keyboardType;
  final int maxLines;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFF344054),
          ),
        ),
        const SizedBox(height: 9),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor:
                const Color(0xFFF9FAFB),
            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFFD0D5DD),
              ),
            ),
            enabledBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFFD0D5DD),
              ),
            ),
            focusedBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFF84CAFF),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/* =========================================================
   상세 정보 행
========================================================= */

class DetailRow extends StatelessWidget {
  final String title;
  final String value;
  final bool showDivider;

  const DetailRow({
    super.key,
    required this.title,
    required this.value,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(
            vertical: 15,
          ),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 88,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w700,
                    color:
                        Color(0xFF667085),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w800,
                    color:
                        Color(0xFF344054),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            color: Color(0xFFEAECF0),
          ),
      ],
    );
  }
}

/* =========================================================
   정렬 항목
========================================================= */

class SortTile extends StatelessWidget {
  final String title;
  final FoodSortType value;
  final FoodSortType selectedValue;

  const SortTile({
    super.key,
    required this.title,
    required this.value,
    required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    final bool selected =
        value == selectedValue;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: selected
              ? FontWeight.w900
              : FontWeight.w600,
        ),
      ),
      trailing: selected
          ? const Icon(
              Icons.check_rounded,
              color: Color(0xFF1570EF),
            )
          : null,
      onTap: () {
        Navigator.pop(
          context,
          value,
        );
      },
    );
  }
}

/* =========================================================
   장보기
========================================================= */

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('장보기'),
      ),
      body: const Center(
        child: Text(
          '장보기 화면',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

/* =========================================================
   설정
========================================================= */

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading:
                Icon(Icons.notifications_outlined),
            title: Text('알림 설정'),
            trailing:
                Icon(Icons.chevron_right_rounded),
          ),
          ListTile(
            leading: Icon(Icons.group_outlined),
            title: Text('냉장고 구성원 관리'),
            trailing:
                Icon(Icons.chevron_right_rounded),
          ),
          ListTile(
            leading:
                Icon(Icons.info_outline_rounded),
            title: Text('앱 정보'),
            trailing:
                Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}

/* =========================================================
   모델 및 ENUM
========================================================= */

enum StorageType {
  refrigerated,
  frozen,
  roomTemperature,
}

extension StorageTypeExtension on StorageType {
  String get label {
    switch (this) {
      case StorageType.refrigerated:
        return '냉장';

      case StorageType.frozen:
        return '냉동';

      case StorageType.roomTemperature:
        return '실온';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case StorageType.refrigerated:
        // 스카이블루 + 시안
        return const Color(0xFFE2F7FC);

      case StorageType.frozen:
        // 연한 딥 블루
        return const Color(0xFFE4EBFA);

      case StorageType.roomTemperature:
        // 베이지
        return const Color(0xFFFFF3DE);
    }
  }

  Color get borderColor {
    switch (this) {
      case StorageType.refrigerated:
        return const Color(0xFF9EDFEA);

      case StorageType.frozen:
        return const Color(0xFFAFC1E8);

      case StorageType.roomTemperature:
        return const Color(0xFFF1D19C);
    }
  }

  Color get foregroundColor {
    switch (this) {
      case StorageType.refrigerated:
        return const Color(0xFF087F8C);

      case StorageType.frozen:
        return const Color(0xFF294C8F);

      case StorageType.roomTemperature:
        return const Color(0xFFA66000);
    }
  }
}

enum FoodSortType {
  expirationSoon,
  recentlyRegistered,
  name,
  quantity,
}

class FoodItem {
  final int id;
  final String name;
  final StorageType storageType;
  final DateTime expirationDate;
  int quantity;
  final String unit;
  final String memo;

  FoodItem({
    required this.id,
    required this.name,
    required this.storageType,
    required this.expirationDate,
    required this.quantity,
    required this.unit,
    required this.memo,
  });
}

/* =========================================================
   날짜 관련 함수
========================================================= */

String getDDayText(DateTime expirationDate) {
  final DateTime now = DateTime.now();

  final DateTime today = DateTime(
    now.year,
    now.month,
    now.day,
  );

  final DateTime target = DateTime(
    expirationDate.year,
    expirationDate.month,
    expirationDate.day,
  );

  final int days =
      target.difference(today).inDays;

  if (days == 0) {
    return 'D-DAY';
  }

  if (days > 0) {
    return 'D-$days';
  }

  return 'D+${days.abs()}';
}

Color getDDayColor(DateTime expirationDate) {
  final DateTime now = DateTime.now();

  final DateTime today = DateTime(
    now.year,
    now.month,
    now.day,
  );

  final DateTime target = DateTime(
    expirationDate.year,
    expirationDate.month,
    expirationDate.day,
  );

  final int days =
      target.difference(today).inDays;

  if (days < 0) {
    return const Color(0xFFD92D20);
  }

  if (days <= 2) {
    return const Color(0xFFD92D20);
  }

  if (days <= 7) {
    return const Color(0xFFDC6803);
  }

  return const Color(0xFF027A48);
}

String formatDate(DateTime date) {
  final String month =
      date.month.toString().padLeft(2, '0');

  final String day =
      date.day.toString().padLeft(2, '0');

  return '${date.year}.$month.$day';
}

