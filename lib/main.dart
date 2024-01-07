import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qartsolution/Constants/databaseService.dart';
import 'package:qartsolution/Constants/provider.dart';
import 'package:qartsolution/Screens/HomeScreen.dart';
import 'package:qartsolution/Screens/SplashScreen.dart';

void main() async {
  _initializeDatabase();
  runApp(const MyApp());
}

void _initializeDatabase() async {
  final dbHelper = DatabaseHelper();
  await dbHelper.database;
  // Perform database operations here, e.g., querying data
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => AppProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
