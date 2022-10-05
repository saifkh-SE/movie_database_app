import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_database_app/backend/api_manager.dart';
import 'package:movie_database_app/models/MovieListItem.dart';
import 'package:movie_database_app/views/home_screen.dart';

String queryText = 'Batman';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  List<MovieListItems> list = [];

  Future<void> loadData() async {
    list = await APIManager().getMoviesList(queryText, 1);
  }

  @override
  void initState() {
    super.initState();
    loadData();

    Future.delayed(
      const Duration(seconds: 2),
      () => Get.off(() => HomeScreen(list)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: FlutterLogo(size: MediaQuery.of(context).size.height),
    );
  }
}
