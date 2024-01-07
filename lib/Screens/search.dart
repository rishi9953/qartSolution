import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:qartsolution/Constants/databaseService.dart';
import 'package:qartsolution/Screens/HomeScreen.dart';
import 'package:qartsolution/Screens/productInfo.dart';

// class Product {
//   final String name;

//   Product({required this.name});
// }

class ProductSearch extends SearchDelegate<dynamic> {
  final List<dynamic> products; // List of products to search through

  ProductSearch({required this.products});

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for the app bar (e.g., clear query button)
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the search query
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left of the app bar
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
        // close(context, products); // Close the search delegate
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show the search results based on the query
    final List<dynamic> searchResults = products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final product = searchResults[index];
        return ListTile(
          title: Text(product['Name']),
          // You can navigate or perform an action with the selected product here
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show suggestions while typing in the search bar (optional)
    final List<dynamic> suggestionList = query.isEmpty
        ? products // Display all products if query is empty
        : products
            .where((product) =>
                product['Option']
                    .toLowerCase()
                    .startsWith(query.toLowerCase()) ||
                product['QRCode'].toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: suggestionList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: calculateAspectRatio(context)),
        itemBuilder: (context, index) {
          final product = suggestionList[index];
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
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(10),
                        Row(
                          children: [
                            Text(
                              product['Name'].toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            InkWell(
                                onTap: () async {
                                  // Map<String, dynamic> row = {
                                  //   'name': 'John Doe',
                                  //   'age': 30,
                                  // };
                                  DatabaseHelper()
                                      .insertData(product)
                                      .whenComplete(() => DatabaseHelper()
                                              .queryAllData()
                                              .then((value) {
                                            print(value);
                                          }));
                                  // DatabaseService.instance
                                  //     .insertRecord(
                                  //   {'myTable': 'Hello sir'},
                                  // );
                                },
                                child: Icon(Icons.favorite_outline))
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
                                style: TextStyle(color: Colors.black),
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
        });
    //  ListView.builder(
    //   itemCount: suggestionList.length,
    //   itemBuilder: (context, index) {
    //     final product = suggestionList[index];
    //     return Container(
    //       margin: EdgeInsets.all(8.0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(product['Name'].toString()),
    //           Gap(10),
    //           Row(
    //             children: [
    //               Container(
    //                 width: 70,
    //                 decoration: BoxDecoration(
    //                     color: Colors.green,
    //                     borderRadius: BorderRadius.circular(10),
    //                     image: DecorationImage(
    //                         fit: BoxFit.cover,
    //                         image: NetworkImage(
    //                           'https://img0.junaroad.com/uiproducts/19126277/zoom_0-1673529652.jpg',
    //                         ))),
    //                 height: 70,
    //               ),
    //               Gap(10),
    //               Expanded(
    //                   child: Container(
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Text(product['Option']),
    //                     Text(
    //                       product['Color'],
    //                       style: TextStyle(fontWeight: FontWeight.bold),
    //                     ),
    //                     Gap(20),
    //                     RichText(
    //                         text: TextSpan(
    //                             style: TextStyle(color: Colors.black),
    //                             text: 'Sizes: ',
    //                             children: [
    //                           TextSpan(
    //                               text:
    //                                   '${product['AvailableSizes'].map((e) => e).join(',')}',
    //                               style: TextStyle(color: Colors.blue))
    //                         ]))
    //                   ],
    //                 ),
    //               ))
    //             ],
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );
  }
}
