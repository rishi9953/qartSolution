import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:qartsolution/Constants/constants.dart';
import 'package:qartsolution/Constants/databaseService.dart';
import 'package:qartsolution/Constants/provider.dart';
import 'package:qartsolution/Screens/HomeScreen.dart';
import 'package:qartsolution/Screens/productInfo.dart';
import 'package:qartsolution/Screens/search.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  dynamic products;

  @override
  void initState() {
    super.initState();
    getData();
  }

  List favoriteProducts = [];
  Future<void> getData() async {
    print('Getting....');
    dynamic data = await ApiServices().fetchProducts();
    List favList = await DatabaseHelper().queryAllData();
    print('Fav List is : $favList');
    if (data != null && data['Products'] != null && favList.isNotEmpty) {
      setState(() {
        favoriteProducts = data['Products']
            .where((product) => favList
                .any((favItem) => favItem['qrCode'] == product['QRCode']))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Gap(
            size.height * 0.035,
          ),
          Container(
            height: size.height * 0.07,
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back)),
                Expanded(
                  child: Text(
                    'Favourite',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .merge(TextStyle(fontWeight: FontWeight.w900)),
                  ),
                ),
                Wrap(
                  children: [
                    InkWell(
                        onTap: () {
                          // showSearch(
                          //   context: context,
                          //   delegate:
                          //       ProductSearch(products: products['Products']),
                          // );
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => SearchScreen()));
                        },
                        child: Icon(Icons.search)),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.shopping_bag_outlined),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: favoriteProducts.length == 0
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: favoriteProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        childAspectRatio: calculateAspectRatio(context)),
                    itemBuilder: (context, index) {
                      final product = favoriteProducts[index];
                      // provider.checkFavouriteList(product);
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductInfo(
                                        productData: product,
                                      )));
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Image.network(
                                'https://img0.junaroad.com/uiproducts/19126277/zoom_0-1673529652.jpg',
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Gap(10),
                                    Text(
                                      product['Name'].toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Gap(4),
                                    // Text(product['Option']),
                                    Text(
                                      product['Color'],
                                    ),
                                    Gap(4),

                                    Text(
                                      '₹${product['MRP']}',
                                    ),
                                    Gap(20),
                                    RichText(
                                        text: TextSpan(
                                            style:
                                                TextStyle(color: Colors.black),
                                            text: 'Sizes: ',
                                            children: [
                                          TextSpan(
                                              text:
                                                  '${product['AvailableSizes'].map((e) => e).join(',')}',
                                              style: TextStyle(
                                                color: Colors.blue,
                                                overflow: TextOverflow.fade,
                                              ))
                                        ]))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
          )
        ],
      ),
    );
  }
}
