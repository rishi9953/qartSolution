import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:qartsolution/Screens/faviouriteScree.dart';
import 'package:qartsolution/Screens/search.dart';

class ProductInfo extends StatefulWidget {
  final dynamic productData;
  const ProductInfo({super.key, required this.productData});

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  int selectedSize = 0;
  int quantity = 0;

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
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back)),
                      Text(
                        'Product Detail',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .merge(TextStyle(fontWeight: FontWeight.w900)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                        'https://img0.junaroad.com/uiproducts/19126277/zoom_0-1673529652.jpg'),
                    Gap(20),
                    Text(
                      '${widget.productData['Name']}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .merge(TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Gap(20),
                    Wrap(
                      children: [
                        ...widget.productData['AvailableSizes']
                            .asMap()
                            .entries
                            .map((e) {
                          int index = e.key;
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedSize = index;
                                });
                              },
                              child: Container(
                                width: size.width * 0.15,
                                height: size.height * 0.07,
                                // // width: size.width * 0.2,
                                // margin: const EdgeInsets.only(right: 10),
                                // color: Colors.yellow,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: selectedSize == index
                                          ? Colors.red
                                          : Colors.grey,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    '${e.value.toString()}',
                                    style: TextStyle(
                                      color: selectedSize == index
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList()
                      ],
                    ),
                    Gap(20),
                    Container(
                      width: size.width * 0.4,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Color.fromARGB(255, 199, 199, 199))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                if (quantity == 1) {
                                } else {
                                  setState(() {
                                    quantity--;
                                  });
                                }
                              },
                              icon: Icon(Icons.remove)),
                          Container(
                            height: 30,
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(255, 199, 199, 199)),
                                right: BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(255, 199, 199, 199)),
                              ),
                            ),
                            width: 50,
                            child: Center(
                              child: Text(
                                "$quantity",
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  quantity++;
                                });
                              },
                              icon: Icon(Icons.add)),
                        ],
                      ),
                    ),
                    Gap(20),
                    Container(
                        width: size.width,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${widget.productData['Category']}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .merge(TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        )),
                    Gap(20),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          '₹${widget.productData['MRP']}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .merge(TextStyle(fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(width: 5),
                        Text(
                          '₹${widget.productData['MRP']}',
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Gap(20),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.red,
                            minimumSize: Size(size.width, size.height * 0.05)),
                        onPressed: () {},
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'ADD TO CART',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward, color: Colors.white)
                          ],
                        )),
                    Gap(20),
                    Text(
                      'Description:',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .merge(TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    Gap(10),
                    Text('${widget.productData['Description']}')
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
