class DropdownMaster {
  final int id;
  final DateTime createdAt;
  final String key;
  final String name;
  final String? description;
  final bool? active;
  final String userId;

  DropdownMaster({
    required this.id,
    required this.createdAt,
    required this.key,
    required this.name,
    this.description,
    this.active,
    required this.userId,
  });

  // From JSON
  factory DropdownMaster.fromJson(Map<String, dynamic> json) {
    return DropdownMaster(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      key: json['key'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      active: json['active'] == null
          ? null
          : (json['active'] is bool
                ? json['active'] as bool
                : json['active'].toString().toLowerCase() == 'true'),
      userId: json['user_id'] as String,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'key': key,
      'name': name,
      'description': description,
      'active': active,
      'user_id': userId,
    };
  }
}
