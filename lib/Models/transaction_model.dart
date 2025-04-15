class Transaction {
  final String type;
  final String title;
  final int points;
  final DateTime dateTime;
  final String? redemptionCode;

  Transaction({
    required this.type,
    required this.title,
    required this.points,
    required this.dateTime,
    this.redemptionCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'points': points,
      'dateTime': dateTime.toIso8601String(),
      'redemptionCode': redemptionCode,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      type: json['type'],
      title: json['title'],
      points: json['points'],
      dateTime: DateTime.parse(json['dateTime']),
      redemptionCode: json['redemptionCode'],
    );
  }
}