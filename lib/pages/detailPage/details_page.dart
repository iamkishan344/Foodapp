import 'package:flutter/material.dart';
import 'package:foodapp/pages/detailPage/components/second_part.dart';
import 'package:foodapp/pages/detailPage/components/top_part.dart';

class DetailsPage extends StatelessWidget {
  final String productImage;
  final String productName;
  final String productCategory;
  final String productId;
  final double productPrice;
  final double productOldPrice;
  final int productRate;
  final String productDescription;
  const DetailsPage({
    Key? key,
    required this.productId,
    required this.productCategory,
    required this.productImage,
    required this.productName,
    required this.productOldPrice,
    required this.productPrice,
    required this.productRate,
    required this.productDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(productId);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopPart(
              productImage: productImage,
            ),
            SecondPart(
              productCategory:productCategory,
              productId: productId,
              productImage: productImage,
              productName: productName,
              productOldPrice: productOldPrice,
              productPrice: productPrice,
              productRate: productRate,
              productDescription: productDescription,
            ),
          ],
        ),
      ),
    );
  }
}
