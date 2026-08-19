import 'package:flutter/material.dart';

import '../../models/food.dart';
import '../../repositories/food_repository.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final FoodRepository foodRepository = FoodRepository();

  final TextEditingController searchController =
      TextEditingController();

  List<Food> allFoods = [];
  List<Food> visibleFoods = [];

  final Map<int, int> foodQuantities = {};

  bool isLoading = true;
  String? errorMessage;

  String selectedStorageType = '전체';
  String selectedSortType = '임박순';

  final List<_StorageFilter> storageFilters = const [
    _StorageFilter(
      name: '전체',
      icon: Icons.grid_view_rounded,
    ),
    _StorageFilter(
      name: '냉장',
      icon: Icons.kitchen_outlined,
    ),
    _StorageFilter(
      name: '냉동',
      icon: Icons.ac_unit_rounded,
    ),
    _StorageFilter(
      name: '실온',
      icon: Icons.inventory_2_outlined,
    ),
  ];

  final List<String> sortTypes = const [
    '임박순',
    '최근 등록순',
    '이름순',
  ];

  @override
  void initState() {
    super.initState();

    searchController.addListener(applyFilter);
    loadFoods();
  }

  @override
  void dispose() {
    searchController.removeListener(applyFilter);
    searchController.dispose();

    super.dispose();
  }

  Future<void> loadFoods() async {
    try {
      final List<Food> result =
          await foodRepository.getFoods();

      if (!mounted) return;

      foodQuantities.clear();

      for (final Food food in result) {
        foodQuantities[food.foodId] = food.quantity;
      }

      setState(() {
        allFoods = result;
        isLoading = false;
        errorMessage = null;
      });

      applyFilter();
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = '식품 목록을 불러오지 못했습니다.';
      });
    }
  }

  void applyFilter() {
    final String keyword =
        searchController.text.trim().toLowerCase();

    final List<Food> result = allFoods.where((food) {
      final bool matchesKeyword =
          food.foodName.toLowerCase().contains(keyword);

      final bool matchesStorage =
          selectedStorageType == '전체' ||
              food.storageType == selectedStorageType;

      return matchesKeyword && matchesStorage;
    }).toList();

    switch (selectedSortType) {
      case '임박순':
        result.sort(
          (a, b) =>
              a.expirationDate.compareTo(b.expirationDate),
        );
        break;

      case '최근 등록순':
        result.sort(
          (a, b) => b.foodId.compareTo(a.foodId),
        );
        break;

      case '이름순':
        result.sort(
          (a, b) => a.foodName.compareTo(b.foodName),
        );
        break;
    }

    if (!mounted) return;

    setState(() {
      visibleFoods = result;
    });
  }

  void changeStorageType(String storageType) {
    selectedStorageType = storageType;
    applyFilter();
  }

  void changeSortType(String? sortType) {
    if (sortType == null) return;

    selectedSortType = sortType;
    applyFilter();
  }

  void decreaseQuantity(Food food) {
    final int currentQuantity =
        foodQuantities[food.foodId] ?? food.quantity;

    if (currentQuantity <= 0) {
      return;
    }

    setState(() {
      foodQuantities[food.foodId] =
          currentQuantity - 1;
    });
  }

  void increaseQuantity(Food food) {
    final int currentQuantity =
        foodQuantities[food.foodId] ?? food.quantity;

    setState(() {
      foodQuantities[food.foodId] =
          currentQuantity + 1;
    });
  }

  Future<void> confirmDeleteFood(Food food) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('식품 삭제'),
          content: Text(
            '${food.foodName}을(를) 삭제하시겠습니까?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('취소'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    setState(() {
      allFoods.removeWhere(
        (item) => item.foodId == food.foodId,
      );

      foodQuantities.remove(food.foodId);
    });

    applyFilter();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${food.foodName}이(가) 삭제되었습니다.',
        ),
      ),
    );
  }

  void openFoodEditPage(Food food) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${food.foodName} 수정 화면으로 연결할 예정입니다.',
        ),
      ),
    );
  }

  Color getStorageMainColor(String storageType) {
    switch (storageType) {
      case '냉장':
        return const Color(0xFF64B5F6);

      case '냉동':
        return const Color(0xFF4F77D9);

      case '실온':
        return const Color(0xFFE5A44D);

      default:
        return const Color(0xFF757575);
    }
  }

  Color getStorageBackgroundColor(String storageType) {
    switch (storageType) {
      case '냉장':
        return const Color(0xFFEAF6FF);

      case '냉동':
        return const Color(0xFFE9EEFF);

      case '실온':
        return const Color(0xFFFFF3E0);

      default:
        return Colors.white;
    }
  }

  Color getStorageBorderColor(String storageType) {
    switch (storageType) {
      case '냉장':
        return const Color(0xFFB9DFFF);

      case '냉동':
        return const Color(0xFFBFCBFA);

      case '실온':
        return const Color(0xFFF2D29F);

      default:
        return const Color(0xFFE0E0E0);
    }
  }

  Color getExpirationColor(Food food) {
    if (food.remainingDays < 0) {
      return Colors.grey.shade700;
    }

    if (food.remainingDays <= 2) {
      return Colors.red;
    }

    if (food.remainingDays <= 7) {
      return Colors.orange.shade700;
    }

    return Colors.green.shade700;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchField(),
        _buildStorageFilters(),
        _buildListHeader(),
        Expanded(
          child: _buildFoodContent(),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        12,
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: '식품명을 검색해 주세요',
          prefixIcon: const Icon(
            Icons.search_rounded,
          ),
          suffixIcon: searchController.text.isEmpty
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
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.grey.shade500,
              width: 1.3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStorageFilters() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: storageFilters.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (context, index) {
          final _StorageFilter filter =
              storageFilters[index];

          final bool isSelected =
              selectedStorageType == filter.name;

          final Color mainColor =
              getStorageMainColor(filter.name);

          final Color backgroundColor =
              getStorageBackgroundColor(filter.name);

          final Color borderColor =
              getStorageBorderColor(filter.name);

          return ChoiceChip(
            avatar: Icon(
              filter.icon,
              size: 18,
              color: filter.name == '전체'
                  ? Colors.grey.shade700
                  : mainColor,
            ),
            label: Text(
              filter.name,
              style: TextStyle(
                fontWeight: isSelected
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: filter.name == '전체'
                    ? Colors.grey.shade800
                    : mainColor,
              ),
            ),
            selected: isSelected,
            showCheckmark: false,
            backgroundColor: backgroundColor,
            selectedColor: backgroundColor,
            side: BorderSide(
              color: isSelected
                  ? mainColor
                  : borderColor,
              width: isSelected ? 2 : 1,
            ),
            labelPadding: const EdgeInsets.only(
              left: 2,
              right: 6,
            ),
            onSelected: (_) {
              changeStorageType(filter.name);
            },
          );
        },
      ),
    );
  }

  Widget _buildListHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        14,
        8,
        8,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$selectedStorageType ${visibleFoods.length}개',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedSortType,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
              ),
              borderRadius: BorderRadius.circular(14),
              items: sortTypes.map((sortType) {
                return DropdownMenuItem<String>(
                  value: sortType,
                  child: Text(
                    sortType,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
              onChanged: changeSortType,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return _ErrorFoodView(
        message: errorMessage!,
        onRetry: loadFoods,
      );
    }

    if (visibleFoods.isEmpty) {
      return const _EmptyFoodView();
    }

    return RefreshIndicator(
      onRefresh: loadFoods,
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(
          16,
          4,
          16,
          110,
        ),
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.05,
        ),
        itemCount: visibleFoods.length,
        itemBuilder: (context, index) {
          final Food food = visibleFoods[index];

          final int quantity =
              foodQuantities[food.foodId] ??
                  food.quantity;

          return _FoodCard(
            food: food,
            quantity: quantity,
            storageColor: getStorageMainColor(
              food.storageType,
            ),
            backgroundColor:
                getStorageBackgroundColor(
              food.storageType,
            ),
            borderColor: getStorageBorderColor(
              food.storageType,
            ),
            expirationColor:
                getExpirationColor(food),
            onTap: () {
              openFoodEditPage(food);
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
    );
  }
}

class _FoodCard extends StatelessWidget {
  final Food food;
  final int quantity;

  final Color storageColor;
  final Color backgroundColor;
  final Color borderColor;
  final Color expirationColor;

  final VoidCallback onTap;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onDelete;

  const _FoodCard({
    required this.food,
    required this.quantity,
    required this.storageColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.expirationColor,
    required this.onTap,
    required this.onDecrease,
    required this.onIncrease,
    required this.onDelete,
  });

  String _formatExpirationDate(DateTime date) {
  final String month =
      date.month.toString().padLeft(2, '0');

  final String day =
      date.day.toString().padLeft(2, '0');

  return '${date.year}.$month.$day';
}

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: borderColor,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.035,
                ),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _buildCardHeader(),
              const Spacer(),
              _buildQuantityControl(),
              const SizedBox(height: 8),
              _buildDeleteButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              food.foodName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                height: 1.25,
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: expirationColor.withValues(
                  alpha: 0.12,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                food.remainingDayText,
                style: TextStyle(
                  fontSize: 15,
                  color: expirationColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ],
    );
  }
  Widget _buildQuantityControl() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.72,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: storageColor.withValues(
            alpha: 0.22,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _QuantityButton(
              icon: Icons.remove_rounded,
              color: storageColor,
              onPressed: onDecrease,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '$quantity${food.unit}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: _QuantityButton(
              icon: Icons.add_rounded,
              color: storageColor,
              onPressed: onIncrease,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton() {
  return Row(
    children: [
      Text(
        '${_formatExpirationDate(food.expirationDate)}까지',
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
      ),

      const Spacer(),

      InkWell(
        onTap: onDelete,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Icon(
            Icons.delete_outline_rounded,
            size: 25,
            color: storageColor,
          ),
        ),
      ),
    ],
  );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _QuantityButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox.expand(
        child: Icon(
          icon,
          size: 21,
          color: color,
        ),
      ),
    );
  }
}

class _EmptyFoodView extends StatelessWidget {
  const _EmptyFoodView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          32,
          20,
          32,
          100,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.kitchen_outlined,
                size: 38,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '등록된 식품이 없습니다',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '식품 등록하기 버튼을 눌러\n'
              '보관 중인 식품을 등록해 보세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorFoodView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorFoodView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StorageFilter {
  final String name;
  final IconData icon;

  const _StorageFilter({
    required this.name,
    required this.icon,
  });
}