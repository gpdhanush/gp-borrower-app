class HistoryMaster {
  final int? id;
  final int? borrowId;
  final int? userId;
  final double? amount;
  final int? typeOfAmount;
  final int? paymentStatus;
  final String? notes;
  final DateTime? paymentDate;
  final DateTime? createdAt;
  final DateTime? updatedDt;
  final int? active;

  HistoryMaster({
    this.id,
    this.borrowId,
    this.userId,
    this.amount,
    this.typeOfAmount,
    this.paymentStatus,
    this.notes,
    this.paymentDate,
    this.createdAt,
    this.updatedDt,
    this.active,
  });

  factory HistoryMaster.fromJson(Map<String, dynamic> json) {
    return HistoryMaster(
      id: json['id'] as int?,
      borrowId: json['borrow_id'] as int?,
      userId: json['user_id'] as int?,
      amount: (json['amount'] as num?)?.toDouble(),
      typeOfAmount: json['type_of_amount'] as int?,
      paymentStatus: json['payment_status'] as int?,
      notes: json['notes'] as String?,
      paymentDate: json['payment_date'] != null
          ? DateTime.parse(json['payment_date'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedDt: json['updated_dt'] != null
          ? DateTime.parse(json['updated_dt'] as String)
          : null,
      active: json['active'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'borrow_id': borrowId,
      'user_id': userId,
      'amount': amount,
      'type_of_amount': typeOfAmount,
      'payment_status': paymentStatus,
      'notes': notes,
      'payment_date': paymentDate?.toIso8601String().split('T').first,
      'created_at': createdAt?.toIso8601String(),
      'updated_dt': updatedDt?.toIso8601String(),
      'active': active,
    };
  }
}

enum AmountType {
  principal(1, 'Principal'),
  interest(2, 'Interest');

  final int id;
  final String name;
  const AmountType(this.id, this.name);
}

enum PaymentStatus {
  pending(1, 'Pending'),
  paid(2, 'Paid'),
  overdue(3, 'Overdue');

  final int id;
  final String name;
  const PaymentStatus(this.id, this.name);
}
