class Food {
  final int foodId;
  final String foodName;
  final String storageType;
  final DateTime expirationDate;
  final int quantity;
  final String unit;
  final String? memo;

  const Food({
    required this.foodId,
    required this.foodName,
    required this.storageType,
    required this.expirationDate,
    required this.quantity,
    required this.unit,
    this.memo,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      foodId: _parseInt(json['foodId']),
      foodName: json['foodName']?.toString() ?? '',
      storageType: json['storageType']?.toString() ?? '',
      expirationDate:
          DateTime.tryParse(json['expirationDate']?.toString() ?? '') ??
              DateTime.now(),
      quantity: _parseInt(json['quantity']),
      unit: json['unit']?.toString() ?? '',
      memo: json['memo']?.toString(),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  int get remainingDays {
    final DateTime today = DateTime.now();

    final DateTime todayOnly = DateTime(
      today.year,
      today.month,
      today.day,
    );

    final DateTime expirationOnly = DateTime(
      expirationDate.year,
      expirationDate.month,
      expirationDate.day,
    );

    return expirationOnly.difference(todayOnly).inDays;
  }

  String get remainingDayText {
    if (remainingDays < 0) {
      return 'D+${remainingDays.abs()}';
    }

    if (remainingDays == 0) {
      return '오늘까지';
    }

    return 'D-$remainingDays';
  }
}