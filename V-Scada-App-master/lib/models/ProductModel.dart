class ProductModel {
  final bool status;
  final String message;
  final List<Product> data;

  ProductModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      status: json['status'],
      message: json['message'],
      data: List<Product>.from(json['data'].map((item) => Product.fromJson(item))),
    );
  }
}

class Product {
  final int id;
  final String productName;
  final String image;
  final String description;
  final String url;
  final String createdAt;
  final String updatedAt;

  Product({
    required this.id,
    required this.productName,
    required this.image,
    required this.description,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      productName: json['product_name'],
      image: json['image'],
      description: json['description'],
      url: json['url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
