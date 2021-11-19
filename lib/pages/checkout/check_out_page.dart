import 'package:flutter/material.dart';
import 'package:foodapp/appColors/app_colors.dart';
import 'package:foodapp/pages/provider/cart_provider.dart';
import 'package:foodapp/widgets/my_button.dart';
import 'package:foodapp/widgets/single_cart_item.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({Key? key}) : super(key: key);

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  late Razorpay _razorpay;
  late double totalPrice;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': num.parse(totalPrice.toString()) * 100,
      'name': ' Corp',
      'description': 'Payment For ANY ',
      'prefill': {
        'contact': '8888888888',
        'email': 'test@razorpay.com',
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Susccess");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Error");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("EXTERNAL_WALLET ");
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    cartProvider.getCartData();

    double subTotal = cartProvider.subTotal();
    // int discount = 5;
    double discount = 5;
    int shipping = 0;

    double discountValue = (subTotal * discount) / 100;
    double value = subTotal - discountValue;
    totalPrice = value += shipping;

    if (cartProvider.getcartList.isEmpty) {
      setState(() {
        totalPrice = 0.0;
      });
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "CheckOut",
          style: TextStyle(
            color: AppColors.KblackColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: cartProvider.getcartList.isEmpty
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
          ),
          Expanded(
            child: Column(
              children: [
                ListTile(
                  leading: Text("Sub Total"),
                  trailing: Text("\$ $subTotal"),
                ),
                ListTile(
                  leading: Text("Discount"),
                  trailing: Text("\$ $discount"),
                ),
                ListTile(
                  leading: Text("Shiping"),
                  trailing: Text("\$ $shipping"),
                ),
                Divider(
                  thickness: 2,
                ),
                ListTile(
                  leading: Text("Total"),
                  trailing: Text("\$ $totalPrice"),
                ),
                cartProvider.getcartList.isEmpty
                    ? Text("")
                    : MyButton(
                        onPressed: () => openCheckout(),
                        text: "Buy",
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
