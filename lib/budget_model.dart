class BudgetProduct {
  final int id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String currency;
  final String image;

  BudgetProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.currency,
    required this.image,
  });

  factory BudgetProduct.fromJson(Map<String, dynamic> json) {
    return BudgetProduct(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,

      name: json['name']?.toString() ?? '',

      description: json['description']?.toString() ?? '',

      category: json['category']?.toString() ?? '',

      price: json['price'] is num
          ? (json['price'] as num).toDouble()
          : double.tryParse('${json['price']}') ?? 0.0,

      currency: json['currency']?.toString() ?? 'PHP',

      image: json['image']?.toString() ?? '',
    );
  }
}
