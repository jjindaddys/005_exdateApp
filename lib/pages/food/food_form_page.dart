  //=================================================================================================//
  //식품 등록/수정 화면===================================================================================//
  //=================================================================================================//
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../models/food.dart';
import 'dart:io';

class FoodFormPage extends StatefulWidget {
  // Food?라서 들어올 수도 있고 null일 수도 있고
  final Food? food;

  const FoodFormPage({
    super.key,
    this.food
  });

  @override
  State<FoodFormPage> createState() => _FoodFormPageState();
}

class _FoodFormPageState extends State<FoodFormPage> {

  //=================================================================================================//
  //변수==============================================================================================//
  //=================================================================================================//

  // 식품 이름 받기
  final TextEditingController nameController = TextEditingController();
  // null이면 등록, null이 아니면 수정
  bool get isEditMode => widget.food != null;
  // 날짜
  DateTime? selectedExpirationDate;
  // 보관 저장소
  String selectedStorageType = '냉장';
  // 보관 선택지
  final List<String> storageTpyes = [
    '냉장',
    '냉동',
    '실온'
  ];
  // 수량 선택
  double quantity = 1;

  // 단위
  String selectedUnit = '개';
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
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
  //=================================================================================================//
  //함수==============================================================================================//
  //=================================================================================================//
  // 날짜 포맷 함수
  String formatDate(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    
    return '${date.year}.$month.$day';
  }

  // 날짜 변경 함수
  Future<void> selectExpirationDate() async {
    // 사용자가 최종적으로 선택한 날짜
    DateTime? pickedDate;

    // 오늘 날짜의 00:00:00 시간이 있으면 에러가남
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(
      now.year,
      now.month,
      now.day,
    );
    final DateTime initialDate =
    selectedExpirationDate ?? today;

    // 아이폰이면
    if(Platform.isIOS) {
      DateTime tempDate = initialDate;
      // ios 스타일의 아래에서 올라오는 팝업 await가 있어서 기다림
      pickedDate = await showCupertinoModalPopup(
        context: context, 
        builder: (context) {
          return Container(
            height: 300,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 220,
                  // CupertinoDatePicker ios 날짜 선택기
                  child: CupertinoDatePicker(
                    // 년월일 만 - date
                    mode: CupertinoDatePickerMode.date,
                    // 처음 열때 위치
                    initialDateTime: selectedExpirationDate,
                    minimumDate: DateTime(
                      today.year - 10,
                      today.month,
                      today.day,
                    ),
                    maximumDate: DateTime(
                      today.year + 10,
                      today.month,
                      today.day,
                    ),
                    // 사용자가 휠을 돌릴 때 마다 실행
                    onDateTimeChanged: (date) {
                      tempDate = date;
                    },
                  ),
                ),
                // 확인버튼 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton(
                    child: const Text('취소'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  CupertinoButton(
                    child: const Text('선택완료'),
                    onPressed: () {
                      Navigator.pop(
                        context,
                        tempDate,
                      );
                    },
                  ),
                ],
              ),
              ],
            ),
          );
        }
      );
    } 
    else {
      pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedExpirationDate,
        firstDate: today,
        lastDate: DateTime(
          today.year + 10,
          today.month,
          today.day,
        ),
        builder: (context, child) {
          return Center(
            child: SizedBox(
              width: 400,
              height: 650,
              child: child!,
            ),
          );
        },
      );
    }
    // 날짜를 취소한 경우
    if(pickedDate == null) {
      return;
    }
    // 유통기한 날짜를 바꿈
    setState(() {
      selectedExpirationDate = pickedDate!;
    });
  }

  // 수량 감소 함수
  void decreaseQuantity() {
    final double step = getQuantityStep();

    if (quantity - step <= 0) {
      return;
    }

    setState(() {
      quantity -= step;
    });
  }
  // 수량 증가 함수
  void increaseQuantity() {
    final double step = getQuantityStep();

    setState(() {
    
      quantity += step;
    });
  }

  // 표시용 함수
  String formatQuantity(double value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    }

    return value.toString();
  }

  // os에따른 수량 위젯
Future<void> selectQuantity() async {
  final List<double> options =
      getQuantityOptions();

  int initialIndex =
      options.indexOf(quantity);

  if (initialIndex == -1) {
    initialIndex = 0;
  }

  double tempQuantity =
      options[initialIndex];

  double? pickedQuantity;

  // iOS
  if (Platform.isIOS) {
    pickedQuantity =
        await showCupertinoModalPopup<double>(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 220,
                child: CupertinoPicker(
                  itemExtent: 40,
                  scrollController:
                      FixedExtentScrollController(
                    initialItem: initialIndex,
                  ),
                  onSelectedItemChanged: (index) {
                    tempQuantity =
                        options[index];
                  },
                  children: options.map((value) {
                    return Center(
                      child: Text(
                        '${formatQuantity(value)}$selectedUnit',
                      ),
                    );
                  }).toList(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton(
                    child: const Text('취소'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  CupertinoButton(
                    child: const Text('선택완료'),
                    onPressed: () {
                      Navigator.pop(
                        context,
                        tempQuantity,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Android
  else {
    double tempQuantity = quantity;

    int initialIndex = options.indexOf(quantity);

    if (initialIndex == -1) {
      initialIndex = 0;
    }

    final ScrollController scrollController =
        ScrollController(
      initialScrollOffset:
          initialIndex * 56.0,
    );

    pickedQuantity =
        await showModalBottomSheet<double>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: SizedBox(
                height: 420,
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    const Text(
                      '수량 선택',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final double value =
                              options[index];

                          final bool isSelected =
                              tempQuantity == value;

                          return ListTile(
                            title: Text(
                              '${formatQuantity(value)}$selectedUnit',
                              textAlign:
                                  TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    isSelected ? 20 : 16,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                              ),
                            ),
                            onTap: () {
                              setModalState(() {
                                tempQuantity = value;
                              });
                            },
                          );
                        },
                      ),
                    ),

                    FilledButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          tempQuantity,
                        );
                      },
                      child: const Text('선택완료'),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('취소'),
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (pickedQuantity == null) {
      return;
    }

    setState(() {
      quantity = pickedQuantity!;
    });
  }
}

  // 단위
  Future<void> selectUnit() async {
  if (Platform.isIOS) {
    String tempUnit = selectedUnit;

    final String? pickedUnit =
        await showCupertinoModalPopup<String>(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 220,
                child: CupertinoPicker(
                  itemExtent: 40,
                  scrollController:
                      FixedExtentScrollController(
                    initialItem:
                        units.indexOf(selectedUnit),
                  ),
                  onSelectedItemChanged: (index) {
                    tempUnit = units[index];
                  },
                  children: units.map((unit) {
                    return Center(
                      child: Text(unit),
                    );
                  }).toList(),
                ),
              ),
              CupertinoButton(
                child: const Text('확11인'),
                onPressed: () {
                  Navigator.pop(
                    context,
                    tempUnit,
                  );
                },
              ),
            ],
          ),
        );
      },
    );

    if (pickedUnit == null) {
      return;
    }

    setState(() {
      selectedUnit = pickedUnit;
    });
  } else {
    final String? pickedUnit =
        await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: units.map((unit) {
              return ListTile(
                title: Text(
                  unit,
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  Navigator.pop(
                    context,
                    unit,
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );

    if (pickedUnit == null) {
      return;
    }

    setState(() {
      selectedUnit = pickedUnit;
    });
  }
}

// 단위에 따른 함수 g, ml는 100씩 Kg, L는 0.5씩 나머지는 1씩 증가또는 감소
double getQuantityStep() {
  switch (selectedUnit) {
    case 'g':
    case 'ml':
      return 100;

    case 'kg':
    case 'L':
      return 0.5;

    default:
      return 1;
  }
}

List<double> getQuantityOptions() {
  switch (selectedUnit) {
    case 'g':
    case 'ml':
      return List.generate(
        50,
        (index) => (index + 1) * 100.0,
      );

    case 'kg':
    case 'L':
      return List.generate(
        100,
        (index) => (index + 1) * 0.5,
      );

    default:
      return List.generate(
        100,
        (index) => (index + 1).toDouble(),
      );
  }
}

// 저장, 수정 함수
void saveFood() {
  // 식품명 입력값 가져오기
  final String foodName = nameController.text.trim();
  // 식품명 검사
  if (foodName.isEmpty) {
    showMessage('식품명을 입력해 주세요.');
    return;
  }
  // 유통기한 검사
  if (selectedExpirationDate == null) {
    showMessage('유통기한을 선택해 주세요.');
    return;
  }
  // 수량 안전 검사
  if (quantity <= 0) {
    showMessage('수량을 확인해 주세요.');
    return;
  }
  // 입력한 내용을 하나로 묶기
  final FoodFormResult result = FoodFormResult(
    foodId: widget.food?.foodId,
    foodName: foodName,
    expirationDate: selectedExpirationDate!,
    storageType: selectedStorageType,
    quantity: quantity,
    unit: selectedUnit,
  );
  // 이전 화면으로 돌아가면서 입력 결과 전달
  Navigator.pop(
    context,
    result,
  );
}

// SnackBar 메세지 이벤트
void showMessage(String message) {
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
}
  //=================================================================================================//
  //위젯==============================================================================================//
  //=================================================================================================//
  // 각 제목 위젯
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // 식품명 입력창 위젯
  Widget _buildNameField() {
    return TextField(
      controller: nameController,
      decoration: InputDecoration(
        hintText: '식품명을 입력해 주세요',
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        // 사용자가 터지하지 않는 상태의 테두리
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        // 사용자가 포커스 한 상태의 테두리
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey .shade700,
            width: 1.3,
          )
        ),
      ),
    );
  }

  // 유통기한 입력칸 위젯
  Widget _buildExpirationDateField() {
    // 단순 반응을 안하는 위젯을 InkWell로 감싸 클릭 이벤트 감지를 하게끔 함
    return InkWell(
      // 누르게 되면 selectExpirationDate 실행
      onTap: selectExpirationDate,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(
          // 가로
          horizontal: 16,
          // 세로
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
                selectedExpirationDate == null
                ? '유통기한을 선택해 주세요'
                : formatDate(selectedExpirationDate!),
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

  // 보관 장소 위젯
  Widget _buildStorageTypeField() {
    // 가로로 배치
    return Row(
      // storageTpyes에 요소를 한번씩 반복 하면서 위젯으로 변환
      children: storageTpyes.map((storageType){
        // isSelected사용자가 선택한것 true false
        final bool isSelected = selectedStorageType == storageType;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: storageType == storageTpyes.last ? 0 : 8,
            ),
            // 여러 선택지 중에 하나만 선택할 수 있음
            child: ChoiceChip(
              label: SizedBox(
                width: double.infinity,
                child: Text(
                  storageType,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
              ), 
              // 선택된 상태인지 전달 true면 활성화된 색
              selected: isSelected,
              showCheckmark: false,
              // 칩을 선택했을때 콜백
              onSelected: (_) {
                setState(() {
                  selectedStorageType = storageType;
                });
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  // 수량 위젯
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
          child: InkWell(
            onTap: selectQuantity,
            borderRadius: BorderRadius.circular(12),
            child: SizedBox.expand(
              child: Center(
                child: Text(
                  '${formatQuantity(quantity)}$selectedUnit',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
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

  // 단위 위젯
Widget _buildUnitField() {
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: units.map((unit) {
      final bool isSelected =
          selectedUnit == unit;

      return ChoiceChip(
        label: Text(unit,
        style: TextStyle(
          fontSize: 18,
        ),
        ),
        selected: isSelected,
        showCheckmark: false,
        onSelected: (_) {
          setState(() {
            selectedUnit = unit;

            // 단위가 바뀌면 해당 단위의 기본 수량으로 변경
            quantity =
                getQuantityOptions().first;
          });
        },
      );
    }).toList(),
  );
}

// 저장버튼, 수정버튼
Widget _buildSaveButton() {
  return SizedBox(
    width: double.infinity,
    height: 52,
    child: FilledButton(
      onPressed: saveFood, 
      child: Text(
        isEditMode ? '수정하기' : '등록하기',
        style: TextStyle(
          fontSize: 18
        ),
      )),
  );
}
  //================================================================//
  //위젯 빌드=========================================================//
  //================================================================//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? '식품 수정' : '식품 등록',
        )
      ),
      // 화면에 TextFild가 있을경우 키보드가 올라오면 짤려서 스크롤이 가능하게 만듬
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        // 세로로 나열
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('식품명'),
            const SizedBox(height: 10,),
            _buildNameField(),          
            const SizedBox(height: 24,),

            _buildSectionTitle('유통기한'),      
            const SizedBox(height: 10,),
            _buildExpirationDateField(),        
            const SizedBox(height: 24,),

            _buildSectionTitle('보관장소'),        
            const SizedBox(height: 10,),
            _buildStorageTypeField(),  
            const SizedBox(height: 24,),

            _buildSectionTitle('단위'),
            const SizedBox(height: 10,),
            _buildUnitField(),
            const SizedBox(height: 24,),

            _buildSectionTitle('수량'),
            const SizedBox(height: 10,),
            _buildQuantityField(),
            const SizedBox(height: 24,),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }
}

// 입력값 class
class FoodFormResult {
  final int? foodId; 
  final String foodName;         // 식품명
  final DateTime expirationDate; // 유통기한
  final String storageType;      // 냉장
  final double quantity;         // 개수
  final String unit;             // 단위

  const FoodFormResult({
    this.foodId,
    required this.foodName,
    required this.expirationDate,
    required this.storageType,
    required this.quantity,
    required this.unit,
  });
}