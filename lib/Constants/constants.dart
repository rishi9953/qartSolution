import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiServices {
  fetchProducts() async {
    var url = Uri.parse(
        'https://ios.qartsolutions.com/api/product/GetProductsWithSizes?retailerCode=40984');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {}
  }
}
