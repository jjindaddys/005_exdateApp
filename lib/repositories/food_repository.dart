import '../models/food.dart';

class FoodRepository {
  Future<List<Food>> getFoods() async {
    await Future<void>.delayed(
      const Duration(milliseconds: 500),
    );

    final DateTime today = DateTime.now();

    return [
      Food(
        foodId: 1,
        foodName: '우유',
        storageType: '냉장',
        expirationDate: today.add(
          const Duration(days: 1),
        ),
        quantity: 1,
        unit: '개',
      ),
      Food(
        foodId: 2,
        foodName: '계란',
        storageType: '냉장',
        expirationDate: today.add(
          const Duration(days: 7),
        ),
        quantity: 10,
        unit: '개',
      ),
      Food(
        foodId: 3,
        foodName: '냉동만두',
        storageType: '냉동',
        expirationDate: today.add(
          const Duration(days: 30),
        ),
        quantity: 2,
        unit: '봉',
      ),
      Food(
        foodId: 4,
        foodName: '양파132123123123123',
        storageType: '실온',
        expirationDate: today.add(
          const Duration(days: 5),
        ),
        quantity: 3,
        unit: '개',
      ),
      Food(
        foodId: 5,
        foodName: '두부',
        storageType: '냉장',
        expirationDate: today,
        quantity: 1,
        unit: '개',
      ),
      Food(
        foodId: 6,
        foodName: '식빵',
        storageType: '실온',
        expirationDate: today.subtract(
          const Duration(days: 1),
        ),
        quantity: 1,
        unit: '봉',
      ),
    ];
  }
}