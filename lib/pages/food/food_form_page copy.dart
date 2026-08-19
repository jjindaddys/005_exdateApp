import 'package:flutter/material.dart';

import '../../models/food.dart';

class FoodFormPage extends StatefulWidget {
  // null이면 등록, Food가 들어오면 수정
  final Food? food;

  const FoodFormPage({
    super.key,
    this.food,
  });

  @override
  State<FoodFormPage> createState() =>
      _FoodFormPageState();
}

class _FoodFormPageState extends State<FoodFormPage> {
  // 식품명 입력창
  final TextEditingController nameController =
      TextEditingController();

  // 등록인지 수정인지 확인
  bool get isEditMode => widget.food != null;

  // 유통기한
  DateTime selectedExpirationDate = DateTime.now();

  // 보관 장소
  String selectedStorageType = '냉장';

  // 수량
  int quantity = 1;

  // 단위
  String selectedUnit = '개';

  final List<String> storageTypes = const [
    '냉장',
    '냉동',
    '실온',
  ];

  final List<String> units = const [
    '개',
    '봉',
    '팩',
    '병',
    '캔',
    'g',
    'kg',
    'ml',
    'L',
  ];

  @override
  void initState() {
    super.initState();

    // 수정 화면이라면 기존 식품 데이터를 입력창에 넣는다.
    final Food? food = widget.food;

    if (food != null) {
      nameController.text = food.foodName;
      selectedExpirationDate = food.expirationDate;
      selectedStorageType = food.storageType;
      quantity = food.quantity;
      selectedUnit = food.unit;
    }
  }

  @override
  void dispose() {
    nameController.dispose();

    super.dispose();
  }

  // 날짜 선택
  Future<void> selectExpirationDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedExpirationDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(
        DateTime.now().year + 10,
      ),
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      selectedExpirationDate = pickedDate;
    });
  }

  // 수량 감소
  void decreaseQuantity() {
    if (quantity <= 1) {
      return;
    }

    setState(() {
      quantity--;
    });
  }

  // 수량 증가
  void increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  // 날짜 화면 표시 형식
  String formatDate(DateTime date) {
    final String month =
        date.month.toString().padLeft(2, '0');

    final String day =
        date.day.toString().padLeft(2, '0');

    return '${date.year}.$month.$day';
  }

  // 등록/수정 완료
  void saveFood() {
    final String foodName =
        nameController.text.trim();

    if (foodName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '식품명을 입력해 주세요.',
          ),
        ),
      );

      return;
    }

    final FoodFormResult result = FoodFormResult(
      foodName: foodName,
      expirationDate: selectedExpirationDate,
      storageType: selectedStorageType,
      quantity: quantity,
      unit: selectedUnit,
    );

    Navigator.pop(
      context,
      result,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? '식품 수정' : '식품 등록',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // 식품명
              _buildSectionTitle('식품명'),
              const SizedBox(height: 8),
              _buildNameField(),

              const SizedBox(height: 24),

              // 유통기한
              _buildSectionTitle('유통기한'),
              const SizedBox(height: 8),
              _buildExpirationDateField(),

              const SizedBox(height: 24),

              // 보관 장소
              _buildSectionTitle('보관 장소'),
              const SizedBox(height: 10),
              _buildStorageTypeField(),

              const SizedBox(height: 24),

              // 수량
              _buildSectionTitle('수량'),
              const SizedBox(height: 10),
              _buildQuantityField(),

              const SizedBox(height: 24),

              // 단위
              _buildSectionTitle('단위'),
              const SizedBox(height: 8),
              _buildUnitField(),

              const SizedBox(height: 40),

              // 등록 / 수정 버튼
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  // 각 항목 제목
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // 식품명 입력창
  Widget _buildNameField() {
    return TextField(
      controller: nameController,
      decoration: InputDecoration(
        hintText: '식품명을 입력해 주세요',
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
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
    );
  }

  // 유통기한 선택
  Widget _buildExpirationDateField() {
    return InkWell(
      onTap: selectExpirationDate,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                formatDate(
                  selectedExpirationDate,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.calendar_month_rounded,
            ),
          ],
        ),
      ),
    );
  }

  // 보관 장소 선택
  Widget _buildStorageTypeField() {
    return Row(
      children: storageTypes.map((storageType) {
        final bool isSelected =
            selectedStorageType == storageType;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right:
                  storageType == storageTypes.last
                      ? 0
                      : 8,
            ),
            child: ChoiceChip(
              label: SizedBox(
                width: double.infinity,
                child: Text(
                  storageType,
                  textAlign: TextAlign.center,
                ),
              ),
              selected: isSelected,
              showCheckmark: false,
              onSelected: (_) {
                setState(() {
                  selectedStorageType =
                      storageType;
                });
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  // 수량 선택
  Widget _buildQuantityField() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: IconButton(
              onPressed: decreaseQuantity,
              icon: const Icon(
                Icons.remove_rounded,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '$quantity$selectedUnit',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: increaseQuantity,
              icon: const Icon(
                Icons.add_rounded,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 단위 선택
  Widget _buildUnitField() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedUnit,
          isExpanded: true,
          borderRadius: BorderRadius.circular(14),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
          ),
          items: units.map((unit) {
            return DropdownMenuItem<String>(
              value: unit,
              child: Text(unit),
            );
          }).toList(),
          onChanged: (unit) {
            if (unit == null) {
              return;
            }

            setState(() {
              selectedUnit = unit;
            });
          },
        ),
      ),
    );
  }

  // 저장 버튼
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        onPressed: saveFood,
        child: Text(
          isEditMode ? '수정하기' : '등록하기',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// 등록/수정 화면에서 입력한 결과
class FoodFormResult {
  final String foodName;
  final DateTime expirationDate;
  final String storageType;
  final int quantity;
  final String unit;

  const FoodFormResult({
    required this.foodName,
    required this.expirationDate,
    required this.storageType,
    required this.quantity,
    required this.unit,
  });
}