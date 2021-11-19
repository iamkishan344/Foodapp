import 'package:flutter/material.dart';

class TopPart extends StatelessWidget {
  final String productImage;
  
  const TopPart({
    Key? key,
    required this.productImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(productImage,),
          ),
        ),
      ),
    );
  }
}
