class Borrower {
  final int id;
  final String name;
  final double amount;
  final int interest;
  final double outstanding;
  final String? description; // Can be null
  final String? mobile; // Can be null
  final DateTime createdAt;
  final String userId;

  Borrower({
    required this.id,
    required this.name,
    required this.amount,
    required this.interest,
    required this.outstanding,
    this.description, // Not required, so can be null
    this.mobile, // Not required, so can be null
    required this.createdAt,
    required this.userId,
  });

  // Factory constructor to create a Borrower from a JSON map
  factory Borrower.fromJson(Map<String, dynamic> json) {
    return Borrower(
      id: json['id'] as int,
      name:
          json['name']
              as String, // Assumed non-nullable by DB schema based on sample 'BORROWER 1'
      amount: (json['amount'] as num)
          .toDouble(), // Supabase might return int for 100000, but amount is double
      interest: json['interest'] as int,
      outstanding: (json['outstanding'] as num).toDouble(), // Same as amount
      // Null-safe handling for potentially nullable fields:
      description:
          json['description']
              as String?, // Use `as String?` to correctly cast to nullable String
      mobile:
          json['mobile']
              as String?, // Use `as String?` to correctly cast to nullable String
      createdAt: DateTime.parse(json['created_at'] as String),
      userId: json['user_id'] as String,
    );
  }

  // Optional: For converting back to JSON if needed (though not strictly part of fixing your error)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'interest': interest,
      'outstanding': outstanding,
      'description': description,
      'mobile': mobile,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
    };
  }
}
