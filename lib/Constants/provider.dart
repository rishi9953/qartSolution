import 'package:flutter/material.dart';
import 'package:qartsolution/Constants/databaseService.dart';

class AppProvider extends ChangeNotifier {
  List favouriteList = [];
  var checkFavourite;
  getFaviourite() async {
    favouriteList = await DatabaseHelper().queryAllData();
    print(favouriteList);
    notifyListeners();
  }
}
