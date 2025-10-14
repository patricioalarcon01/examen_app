class Category {
  final int id;
  final String name;
  final String state;

  Category({required this.id, required this.name, required this.state});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['category_id'] ?? 0,
        name: json['category_name'] ?? '',
        state: json['category_state'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'category_id': id,
        'category_name': name,
        'category_state': state,
      };
}
