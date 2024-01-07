import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:qartsolution/Constants/constants.dart';
import 'package:qartsolution/Constants/databaseService.dart';
import 'package:qartsolution/Constants/provider.dart';
import 'package:qartsolution/Screens/faviouriteScree.dart';
import 'package:qartsolution/Screens/productInfo.dart';
import 'package:qartsolution/Screens/search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  dynamic products;
  List favList = [];
  @override
  void initState() {
    super.initState();

    getData();
  }

  // void initDb() async {
  //   DatabaseService.instance.initialize();
  // }

  Future<void> getData() async {
    dynamic data = await ApiServices().fetchProducts();

    setState(() {
      products = data;
    });

    print('Data is : $products');
    checkFavList();
  }

  Future checkFavList() async {
    favList = await DatabaseHelper().queryAllData();
    setState(() {});
    print(favList);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth ~/ 150;
    double aspectRatio = screenWidth / (crossAxisCount * 150);
    var provider = Provider.of<AppProvider>(context, listen: false);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          return getData();
        },
        child: Column(
          children: [
            Gap(
              size.height * 0.035,
            ),
            Container(
              height: size.height * 0.07,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Qart Solutions',
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
                            showSearch(
                              context: context,
                              delegate:
                                  ProductSearch(products: products['Products']),
                            );
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => SearchScreen()));
                          },
                          child: Icon(Icons.search)),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Favourite()));
                          },
                          child: Icon(Icons.favorite_outline)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: products == null
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: products['Products'].length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                          childAspectRatio: calculateAspectRatio(context)),
                      itemBuilder: (context, index) {
                        final product = products['Products'][index];
                        // checkFavList(product);
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Gap(10),
                                      Row(
                                        children: [
                                          Text(
                                            product['Name'].toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Spacer(),
                                          InkWell(
                                              onTap: () async {
                                                if (favList.any((element) =>
                                                        element['qrCode'] ==
                                                        product['QRCode']) ==
                                                    false) {
                                                  Map<String, dynamic> row = {
                                                    'name':
                                                        '${product['Name']}',
                                                    'gender':
                                                        '${product['Gender']}',
                                                    'category':
                                                        '${product['Category']}',
                                                    'fit': '${product['Fit']}',
                                                    'qrcode':
                                                        '${product['QRCode']}',
                                                    'mrp': product['MRP'],
                                                    'description':
                                                        product['Description']
                                                  };
                                                  DatabaseHelper()
                                                      .insertData(row)
                                                      .whenComplete(() {
                                                    checkFavList();
                                                    DatabaseHelper()
                                                        .queryAllData()
                                                        .then((value) =>
                                                            print(value));
                                                    checkFavList();
                                                    // provider
                                                    //     .checkFavouriteList(product);
                                                  });
                                                  // DatabaseService.instance
                                                  //     .insertRecord(
                                                  //   {'myTable': 'Hello sir'},
                                                  // );
                                                } else {
                                                  // var id = favList.where(
                                                  //     (element) => element[
                                                  //                 'qrCode'] ==
                                                  //             product['QRCode']
                                                  //         ? element
                                                  //         : null);
                                                  print('id is : ');
                                                }
                                              },
                                              child: favList.any((element) =>
                                                          element['qrCode'] ==
                                                          product['QRCode']) ==
                                                      false
                                                  ? Icon(Icons.favorite_outline)
                                                  : Icon(
                                                      Icons.favorite,
                                                      color: Colors.red,
                                                    ))
                                        ],
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
                                              style: TextStyle(
                                                  color: Colors.black),
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
            ),
          ],
        ),
      ),
    );
  }
}

double calculateAspectRatio(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  int crossAxisSpacing = 2;
  final itemWidth = (screenWidth - crossAxisSpacing) / 1.89;
  return itemWidth / screenWidth;
}
