import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  final String productImage;
  final String productName;
  final double productPrice;
  final int productQuantity;
  final String productCategory;
  final String productId;
  CartModel({
    required this.productId,
    required this.productCategory,
    required this.productImage,
    required this.productName,
    required this.productPrice,
    required this.productQuantity,
  });
  factory CartModel.fromDocument(QueryDocumentSnapshot doc) {
    return CartModel(
      productId: doc["productId"],
      productCategory: doc["productCategory"],
      productImage: doc["productImage"],
      productName: doc["productName"],
      productPrice: doc["productPrice"],
      productQuantity: doc["productQuantity"],
    );
  }
}
