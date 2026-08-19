import 'package:exdateapp/pages/food/food_form_page.dart';
import 'package:flutter/material.dart';

// 식품 하나의 데이터를 표현하는 Food모델
import '../../models/food.dart';
// 식품 데이터를 가져오는 역할
import '../../repositories/food_repository.dart';

// 내용이 바뀌어서 StatefulWidget사용
class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {

  // 임의 데이터 저장소
  final FoodRepository foodRepository = FoodRepository();
  // 검색창 controller
  final TextEditingController searchController = TextEditingController();
  // 전체 식품 목록
  List<Food> allFoods = [];
  // 선택 식품 목록
  List<Food> visibleFoods = [];
  // 식품 수량
  final Map<int, int> foodQuantities = {};
  // 로딩
  bool isLoading = true;
  // 오류상태 String? null도 허용
  String? errorMessage;
  // 초기설정 - 전체
  String selectedStorageType = '전체';
  // 초기설정 - 임박순
  String selectedSortType = '임박순';
  
  // 필터 항목
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

  // 앱 초기 딱 한 번 실행
  @override
  void initState() {
    super.initState();
    // addListener 감시자 추가
    searchController.addListener(applyFilter);
    // 식품 데이터 가져오기
    loadFoods();
  }
  // 화면이 없어질 때 딱 한 번 실행
  @override
  void dispose() {
    // 서치컨트롤러 감시 끝내기
    searchController.removeListener(applyFilter);
    // 서치컨트롤러 메모리 정리
    searchController.dispose();
    // 부모도 마무리 정리
    super.dispose();
  }

  // 데이터 가져올 때 작업이 바로 끝나지 않아 Future 비동기 사용
  Future<void> loadFoods() async {
    try {
      // 정상
      final List<Food> result = await foodRepository.getFoods();
      // 현재 화면이 _FoodPageState 연결되있는가 확인
      if(!mounted) return;
      // 데이터를 새로 불러왔으니 수량정보를 clear
      foodQuantities.clear();
      // 저장소에서 받은 것을 for로 돌려 foodQuantitles에 저장
      for(final Food food in result) {
        foodQuantities[food.foodId] = food.quantity;
      }

      // setState하고 화면을 다시 그림 -> Build
      setState(() {
        // 전체 식품목록을 allFoods에 저장
        allFoods = result;
        // 데이터 받았으므로 로딩 false
        isLoading = false;
        // 에러 없음 null
        errorMessage = null;
      });
      // 검색, 필터, 정렬 적용
      applyFilter();

    } catch (error) {
      // 오류
      if(!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = '식품 목록을 불러오지 못했습니다.';
      });
      
    }
  }
  // 검색, 필터, 정렬 이벤트
  void applyFilter() {
    // searchController.text 검색창에 입력된 값을 가져온다. trim() 앞뒤 공백을 없앤다 toLowerCase소문자로
    final String keyword = searchController.text.trim().toLowerCase();    
    // where 조건에 맞는 식품만 남긴다
    final List<Food> result = allFoods.where((food) {
      final bool matchesKeyword = food.foodName.toLowerCase().contains(keyword);
      final bool mathesStorage = selectedStorageType == '전체' || food.storageType == selectedStorageType;
      return matchesKeyword && mathesStorage;
    }).toList();

    switch (selectedSortType) {
      case '임박순':
      result.sort(
        (a, b) => a.expirationDate.compareTo(b.expirationDate),
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
    if(!mounted) return;
    setState(() {
      visibleFoods = result;
    });
  }

  // 정렬 변경 함수
  void changeSortType(String? sortTpye) {
    if (sortTpye == null) return;

    selectedSortType = sortTpye;
    applyFilter();
  }

  // 필터 클릭 이벤트
  void changeStorageType(String storageType) {
    selectedStorageType = storageType;
    applyFilter();
  }

  // 필터 장소 대표 색상
  Color getStorageMainColor(String storageType) {
    switch (storageType) {
      case '냉장':
        // 밝은 파랑색
        return const Color(0xFF64B5F6);
      case '냉동':
        // 진한 파란색
        return const Color(0xFF4F77D9);
      case '실온':
        // 주황색
        return const Color(0xFFE5A44D);
      default:
        // 기본 회색
        return const Color(0xFF757575);
    }
  }
  // 필터의 배경색
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

  // 유통기한에 따라 색상을 변경함
  Color getExpirationColor(Food food) {
    // 0일보다 작을 떄
    if(food.remainingDays < 0) {
      return Colors.grey.shade700;
    }
    // 2일 이하 남음
    if(food.remainingDays <= 2) {
      return Colors.red;
    }
    // 7일 이하 남음
    if(food.remainingDays <= 7) {
      return Colors.orange.shade700;
    }
    // 아무것도 아님 
    return Colors.green.shade700;
  }
 
  // 수량 감소 함수
  void decreaseQuantity(Food food) {
    final int currentQuantity = foodQuantities[food.foodId] ?? food.quantity;

    if(currentQuantity <= 0) {
      return;
    }

    setState(() {
      foodQuantities[food.foodId] = currentQuantity -1;
    });
  }

  // 수량 증가 함수
  void increaseQuantity(Food food) {
    final int currentQuantity = foodQuantities[food.foodId] ?? food.quantity;

    setState(() {
      foodQuantities[food.foodId] = currentQuantity +1;
    });
  }

  // 수정 화면 연결 
  void openFoodEditPage(Food food) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodFormPage(food: food))
    );
  }

  // 삭제 함수
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
              child: const Text('취소')
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              }, 
              child: const Text('삭제'),
              
            )
          ],
        );
      }
    );

    if(shouldDelete!=true) return;

    setState(() {
      allFoods.removeWhere(
        (item) => item.foodId == food.foodId,
      );
      foodQuantities.remove(food.foodId);
    });

    applyFilter();

    if(!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${food.foodName}이(가) 삭제되었습니다.',
        )
      )
    );
  }

  // 상단의 검색창
  Widget _buildSearchField() {
    return Padding(
      padding: 
        const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: '식품을 검색해 주세요.',
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
              )
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            // 기본 형태의 테두리
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
        ),
    );
  }

  // 필터 위젯
  Widget _buildStorageFilters() {
    return SizedBox(
      // 필터의 영역 높이를 44로 고정
      height: 44,
      // ListView.separated 필터가 화면 너비보다 많아질 경우 가로로 스크롤 할수 있게
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        // 기본 스크롤은 세로인데 가로로 바꿔버림 Axis.horizontal
        scrollDirection: Axis.horizontal,
        // 몇개를 만들지 결정 storageFilters의개수만큼 itemBuilder가 네번 실행됨
        itemCount: storageFilters.length,
        // 필터 사이에 가로 8 여백
        separatorBuilder: (context, index) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (context, index) {
          // storageFilters 인덱스로 fliter에다가 전체, 냉장, 냉동, 실온을 담는다 각 1번씩 실행
          final _StorageFilter filter = storageFilters[index];
          final bool isSelected = selectedStorageType == filter.name;
          final Color mainColor = getStorageMainColor(filter.name);
          final Color backgroundColor = getStorageBackgroundColor(filter.name);
          final Color borderColor = getStorageBorderColor(filter.name);
          // ChiceChip 여러 선택지 중 선택 할때 유용
          return ChoiceChip(
            // 칩의 아이콘
            avatar: Icon(
              filter.icon,
              size: 18,
              color: filter.name == '전체'
                ? Colors.grey.shade700
                : mainColor,
            ),
            // 칩의 텍스트
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
            // 칩의 테두리
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

  // 필터 개수 + 정렬 드롭 다운
  Widget _buildListHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        14,
        8,
        8,
      ),
      // Row 위젯을 가로로 배치
      child: Row(
        children: [
          // Row안에서 자식 위젯이 남은 가로 공간을 최대한 차지하도록 확장 시켜줌
          Expanded(
            child: Text(
              '$selectedStorageType ${visibleFoods.length}개',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          // 드롭다운의 자동으로 생기는 밑줄 제거
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              // 현재 표시될 값 - 임박순
              value: selectedSortType,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
              ),
              borderRadius: BorderRadius.circular(14),
              // 드롭다운 클릭시 열리는 메뉴 목록
              items: sortTypes.map((sortType) {
                return DropdownMenuItem<String>(
                  // 실제 value데이터 값
                  value: sortType,
                  child: Text(
                    sortType,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
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
    // 로딩중이면
    if(isLoading) {
      return const Center(
        // 로딩 원을 보여준다
        child: CircularProgressIndicator(),
      );
    }
    // // 에러
    if(errorMessage != null) {
      return _ErrorFoodView(
        message: errorMessage!,
        onRetry: loadFoods,
      );
    }
    // // 식품이 없으면 빈 화면을 보여줌
    if(visibleFoods.isEmpty) {
      return const _EmptyFoodView();
    }

    // RefreshIndicator 화면을 하래로 끌어당겼을 떄 새로고침 동작을 수행 함
    return RefreshIndicator(
      // 리프레쉬 함수 loadFoods
      onRefresh: loadFoods, 
      // 바둑판 형태로 보여주는 위젯
      child: GridView.builder(
        // 그리드 안쪽 여백을 준다
        padding: const EdgeInsets.fromLTRB(
          16, 
          4, 
          16, 
          110,
        ),
        // 아이템 개수가 적어도 스크롤이 가능하게 만들어준다
        physics: const AlwaysScrollableScrollPhysics(),
        // gridDelegate 그리드 격자 형태와 레이아웃을 정의한다
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          // 가로로 2개씩 배치
          crossAxisCount: 2,
          // 가로 카드 사이의 간격을 12픽셀로 준다
          crossAxisSpacing: 12,
          // 세로 카드 사이의 간격을 12픽셀로 준다
          mainAxisSpacing: 12,
          // 각 카드의 가로 대 세로 비율
          childAspectRatio: 1.05,
        ), 
        // itemCount 그리드에 그릴 총 개수
        itemCount: visibleFoods.length,
        // itemBuilder 각각의 칸에 어떤 위젯을 그릴지 정의
        itemBuilder: (context, index) {
          // 현재 순서에 해당하는 식품 객체를 가져옴
          final Food food = visibleFoods[index];
          // foodQuantities가 없으면 food.quantity를 사용
          final int quantity = foodQuantities[food.foodId] ?? food.quantity;
          // 개별식품 카드 위젯을 생성해서 반환한다
          return _FoodCard(
            // 식품 정보
            food: food,
            // 수량
            quantity: quantity,
            storageColor: getStorageMainColor(food.storageType),
            backgroundColor: getStorageBackgroundColor(food.storageType),
            borderColor: getStorageBorderColor(food.storageType),
            expirationColor: getExpirationColor(food),
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
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 검색창
        _buildSearchField(),
        // 전체, 냉동, 냉장, 실온 필터
        _buildStorageFilters(),
        // 식품 개수와 정렬 선택
        _buildListHeader(),
        // 실제 식품 목록 - 남은 목록 _buildFoodContent로 채우게 끔
        Expanded(
          child: _buildFoodContent()),
      ],
    );
  }
}

// 필터 항목 class
class _StorageFilter {
  final String name;
  final IconData icon;

  const _StorageFilter({
    required this.name,
    required this.icon,
  });
}

// 식품 카드 class
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
    // 카드의 물결 효과를 쓰기 위해 Material사용
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(18),
      // 카드를 터치했을 때 물결 효과
      child: InkWell(
        // 카드를 터치했을 때 함수
        onTap: onTap,
        // 물결 효과의 범위를 모서리 18에맞게 함
        borderRadius: BorderRadius.circular(18),
        // 테두리, 그림자, 여백 디자인 스타일
        child: Container(
          // 여백을 상하좌우 14씩 준다
          padding: const EdgeInsets.all(14),
          // 디자인
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(18),
            // 카드의 테두리 1.2픽셀 두께로 만듬
            border: Border.all(
              color: borderColor,
              width: 1.2,
            ),
            // 카드가 화면에서 약하게 떠 있는 듯한 입체감을 주기 위해 사용 boxshadow
            boxShadow: [
              BoxShadow(
                // 매우 옅은 검은색
                color: Colors.black.withValues(
                  // 투명도 약 3.5%
                  alpha: 0.035,
                ),
                // 흐림정도를 10픽셀로 퍼지게 함
                blurRadius: 10,
                // 그림자를 가로 0 세로 3아래쪽으로 3픽셀 이동시킴
                offset: const Offset(0, 3),
              ),
            ]
          ),
          // Column세로로 나란히 배치
          child: Column(
            // 내부 요소들을 왼쪽 정렬 함
            crossAxisAlignment: 
              CrossAxisAlignment.start,
            children: [
              _buildCardHeader(),
              // Expanded의 반대 세로 빈 공간을 혼자 다 차지하게 함
              const Spacer(),
              _buildQuantityControl(),
              const SizedBox(height: 8,),
              _buildDeleteButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader() {
    // Row가로로 배치하기 위함
    return Row(
      // 가로로 배치할 위젯들의 위쪽 기준점 상단정렬을 맞춘다
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              // 식품 이름 표시
              food.foodName,
              // 식품 이름이 너무 길 경우 최대 2줄까지
              maxLines: 1,
              // 2줄을 초과할 정도로 길면 ...처리함
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                height: 1.25
              ),
            ),
          )
        ),
        const SizedBox(width: 6,),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: expirationColor.withValues(
              alpha: 0.15,
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
        )
      ],
    );
  }

  // 수량 플러스 마이너스 위젯
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

  // 유통기한 날짜 + 휴지통 위젯
  Widget _buildDeleteButton() {
    return Row(
      children: [
        Text(
          '${_formatExpirationDate(food.expirationDate)}',
          style: TextStyle(
            fontSize: 12,
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
        )
      ],
    );
  }
}

// quantityButton class
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

// 식품이 하나도 없을 때
class _EmptyFoodView extends StatelessWidget {
  const _EmptyFoodView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(32, 20, 32, 100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                // 원형의 아이콘
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.kitchen_outlined,
                size: 38,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 30,),
            const Text(
              '등록된 식품이 없습니다.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8,),
            Text(
              '식품 등록하기 버튼을 눌러\n'
              '보관 중인 식품을 등록해 보세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            )
          ],
        )
      ),
    );    
  }
}

// 오류 화면
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
            const SizedBox(height: 16,),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16,),
            FilledButton(
              onPressed: onRetry, 
              child: Text(
                '다시 시도'
              )
            )
          ],
        ),
      ),
    );
  }
}

  
  

