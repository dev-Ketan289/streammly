import 'package:streammly/models/package/product_model.dart';

class ProductInPackage {
  final int id;
  final int packageId;
  final int productId;
  final String itemType;
  final String dataRequestStage;
  final int quantity;
  final Product product;

  ProductInPackage({
    required this.id,
    required this.packageId,
    required this.productId,
    required this.itemType,
    required this.dataRequestStage,
    required this.quantity,
    required this.product,
  });

  factory ProductInPackage.fromJson(Map<String, dynamic> json) {
    return ProductInPackage(
      id: json['id'],
      packageId: json['package_id'],
      productId: json['product_id'],
      itemType: json['item_type'] ?? '',
      dataRequestStage: json['data_request_stage'] ?? '',
      quantity: json['quantity'] ?? 0,
      product: Product.fromJson(json['products'] ?? {}),
    );
  }
}
