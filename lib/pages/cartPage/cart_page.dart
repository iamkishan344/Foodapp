import 'package:flutter/material.dart';
import 'package:foodapp/pages/checkout/check_out_page.dart';
import 'package:foodapp/pages/provider/cart_provider.dart';
import 'package:foodapp/route/routing_page.dart';
import 'package:foodapp/widgets/my_button.dart';
import 'package:foodapp/widgets/single_cart_item.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    cartProvider.getCartData();
    return Scaffold(
      bottomNavigationBar: cartProvider.getcartList.isEmpty
          ? Text("")
          : MyButton(
              text: "Check Out",
              onPressed: () {
                RoutingPage.goTonext(
                  context: context,
                  navigateTo: CheckOutPage(),
                );
              },
            ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: cartProvider.getcartList.isEmpty
          ? Center(
              child: Text("Empty Cart 🛒🛒🛒 "),
            )
          : ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: cartProvider.getcartList.length,
              itemBuilder: (ctx, index) {
                var data = cartProvider.cartList[index];
                return SingleCartItem(
                  productId: data.productId,
                  productCategory: data.productCategory,
                  productImage: data.productImage,
                  productName: data.productName,
                  productPrice: data.productPrice,
                  productQuantity: data.productQuantity,
                );
              },
            ),
    );
  }
}
