import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/appColors/app_colors.dart';
import 'package:foodapp/model/user_model.dart';
import 'package:foodapp/pages/cartPage/cart_page.dart';
import 'package:foodapp/pages/detailPage/details_page.dart';
import 'package:foodapp/route/routing_page.dart';
import 'package:foodapp/widgets/build_drawer.dart';
import 'package:foodapp/widgets/grid_view_widget.dart';
import 'package:foodapp/widgets/single_product.dart';

late UserModel userModel;

Size? size;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String query = "";
  var result;

  searchFunction(query, searchList) {
    result = searchList.where((element) {
      return element["productName"]
              .toUpperCase()
              .toLowerCase()
              .contains(query) ||
          element["productName"].toUpperCase().toLowerCase().contains(query) ||
          element["productName"].toUpperCase().toLowerCase().contains(query) &&
              element["productName"]
                  .toUpperCase()
                  .toLowerCase()
                  .contains(query);
    }).toList();
    return result;
  }

  Future getCurrentUserDataFunction() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
      (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          userModel = UserModel.fromDocument(documentSnapshot);
        } else {
          print("Document does not exits tha database");
        }
      },
    );
  }

  Widget buildCategroy() {
    return Column(
      children: [
        ListTile(
          leading: Text(
            "Categories",
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        Container(
          height: size!.height * 0.1 + 20,
          child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("categories").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshort) {
              if (!streamSnapshort.hasData) {
                return Center(child: const CircularProgressIndicator());
              }
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: streamSnapshort.data!.docs.length,
                  itemBuilder: (ctx, index) {
                    return Categories(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => GridViewWidget(
                              subCollection: streamSnapshort.data!.docs[index]
                                  ["categoryName"],
                              collection: "categories",
                              id: streamSnapshort.data!.docs[index].id,
                            ),
                          ),
                        );
                      },
                      categoryName: streamSnapshort.data!.docs[index]
                          ["categoryName"],
                      image: streamSnapshort.data!.docs[index]["categoryImage"],
                    );
                  });
            },
          ),
        ),
      ],
    );
  }

  Widget buildProduct(
      {required Stream<QuerySnapshot<Map<String, dynamic>>>? stream}) {
    return Container(
      height: size!.height / 3 + 40,
      child: StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshort) {
          if (!streamSnapshort.hasData) {
            return Center(child: const CircularProgressIndicator());
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount: streamSnapshort.data!.docs.length,
            itemBuilder: (ctx, index) {
              var varData = searchFunction(query, streamSnapshort.data!.docs);
              var data = varData[index];
              // var data = streamSnapshort.data!.docs[index];
              return SingleProduct(
                onTap: () {
                  RoutingPage.goTonext(
                    context: context,
                    navigateTo: DetailsPage(
                      productImage: data["productImage"],
                      productCategory: data["productCategory"],
                      productName: data["productName"],
                      productPrice: data["productPrice"],
                      productId: data["productId"],
                      productOldPrice: data["productOldPrice"],
                      productRate: data["productRate"],
                      productDescription: data["productDescription"],
                    ),
                  );
                },
                productId: data["productId"],
                productCategory: data["productCategory"],
                productName: data["productName"],
                productImage: data["productImage"],
                productOldPrice: data["productOldPrice"],
                productPrice: data["productPrice"],
                productRate: data["productRate"],
                // productFavorite: data["productFavorite"],
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    getCurrentUserDataFunction();
    return Scaffold(
      drawer: BuildDrawer(),
      appBar: AppBar(
        title: Text(
          "FoodApp",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        // titleSpacing: 0,
        actions: [
          IconButton(
            onPressed: () {
              RoutingPage.goTonext(
                context: context,
                navigateTo: CartPage(),
              );
            },
            icon: Icon(
              Icons.shopping_cart_rounded,
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 7,
              shadowColor: Colors.grey[300],
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    query = value;
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  fillColor: AppColors.KwhiteColor,
                  hintText: "Search Your Product",
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          query == ""
              ? Column(
                  children: [
                    buildCategroy(),
                    ListTile(
                      leading: Text(
                        "Products",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    buildProduct(
                      stream: FirebaseFirestore.instance
                          .collection("products")
                          .snapshots(),
                    ),
                    ListTile(
                      leading: Text(
                        "Best Sell",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    buildProduct(
                      stream: FirebaseFirestore.instance
                          .collection("products")
                          .where("productRate", isGreaterThan: 5)
                          .orderBy(
                            "productRate",
                            descending: true,
                          )
                          .snapshots(),
                    ),
                  ],
                )
              : Container(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("products")
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot> streamSnapshort) {
                      if (!streamSnapshort.hasData) {
                        return Center(child: const CircularProgressIndicator());
                      }
                      var varData =
                          searchFunction(query, streamSnapshort.data!.docs);
                      return result.isEmpty
                          ? Center(child: Text("Not Found"))
                          : GridView.builder(
                              shrinkWrap: true,
                              itemCount: result.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5.0,
                                mainAxisSpacing: 5.0,
                                childAspectRatio: 0.6,
                              ),
                              itemBuilder: (ctx, index) {
                                var data = varData[index];
                                return SingleProduct(
                                  onTap: () {
                                    RoutingPage.goTonext(
                                      context: context,
                                      navigateTo: DetailsPage(
                                        productImage: data["productImage"],
                                        productCategory:
                                            data["productCategory"],
                                        productName: data["productName"],
                                        productPrice: data["productPrice"],
                                        productId: data["productId"],
                                        productOldPrice:
                                            data["productOldPrice"],
                                        productRate: data["productRate"],
                                        productDescription:
                                            data["productDescription"],
                                      ),
                                    );
                                  },
                                  productId: data["productId"],
                                  productCategory: data["productCategory"],
                                  productName: data["productName"],
                                  productImage: data["productImage"],
                                  productOldPrice: data["productOldPrice"],
                                  productPrice: data["productPrice"],
                                  productRate: data["productRate"],
                                );
                              },
                            );
                    },
                  ),
                ),
          SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}

class Categories extends StatelessWidget {
  final String image;
  final String categoryName;
  final Function()? onTap;
  const Categories({
    Key? key,
    required this.onTap,
    required this.categoryName,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(12.0),
        width: size!.width / 2 - 20,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              image,
            ),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black.withOpacity(0.7),
          ),
          child: Center(
            child: Text(
              categoryName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
