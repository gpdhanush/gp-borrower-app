class HistoryMaster {
  final int id;
  final int? borrowId;
  final double? amount;
  final int? typeOfAmount;
  final int? paymentStatus;
  final String? notes;
  final DateTime? paymentDate;
  final DateTime createdAt;
  final DateTime? updatedDt;
  final int? active;
  final String userId;

  // Joined fields
  final String? borrowName;
  final String? typeName;
  final String? statusName;

  HistoryMaster({
    required this.id,
    this.borrowId,
    this.amount,
    this.typeOfAmount,
    this.paymentStatus,
    this.notes,
    this.paymentDate,
    required this.createdAt,
    this.updatedDt,
    this.active,
    required this.userId,
    this.borrowName,
    this.typeName,
    this.statusName,
  });

  factory HistoryMaster.fromJson(Map<String, dynamic> json) {
    return HistoryMaster(
      id: json['id'] as int,
      borrowId: json['borrow_id'] as int?,
      amount: json['amount'] != null
          ? (json['amount'] as num).toDouble()
          : null,
      typeOfAmount: json['type_of_amount'] as int?,
      paymentStatus: json['payment_status'] as int?,
      notes: json['notes'] as String?,
      paymentDate: json['payment_date'] != null
          ? DateTime.parse(json['payment_date'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedDt: json['updated_dt'] != null
          ? DateTime.parse(json['updated_dt'])
          : null,
      active: json['active'] != null ? json['active'] as int : null,
      userId: json['user_id'] as String,
      borrowName: json['borrow_name'] as String?,
      typeName: json['type_name'] as String?,
      statusName: json['status_name'] as String?,
    );
  }
}
