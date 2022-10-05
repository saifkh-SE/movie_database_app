import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_database_app/models/MovieDetails.dart';
import 'package:movie_database_app/models/MovieListItem.dart';

class APIManager {
  String apiKey = 'ceb91124';

  Future<List<MovieListItems>> getMoviesList(String searchCriteria, int pageNum) async {
    var client = http.Client();
    String url = 'https://www.omdbapi.com/?apikey=$apiKey&s=$searchCriteria&page=$pageNum';
    List<MovieListItems> list = <MovieListItems>[];

    try {
      var response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['Search'];
        //return jsonMap;
        list = jsonResponse.map((data) => MovieListItems.fromJson(data)).toList();
      }
    } catch (exception) {
      // ignore: avoid_print
      print(exception);
    }
    return list;
  }

  // Future<List<MovieListItem>> getMoviesList(String searchCriteria, int pageNum) async {
  //   var client = http.Client();
  //   String url = 'https://www.omdbapi.com/?apikey=$apiKey&s=$searchCriteria&page=$pageNum';
  //   late List<MovieListItem> list;

  //   try {
  //     var response = await client.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       var jsonString = response.body;
  //       var jsonMap = json.decode(jsonString);
  //       //return jsonMap;
  //       list = List<MovieListItem>.from(jsonMap);
  //     }
  //   } catch (exception) {
  //     // ignore: avoid_print
  //     print(exception);
  //   }
  //   return list;
  // }

  Future<MovieDetails> getMoviesDetails(String searchCriteria) async {
    var client = http.Client();
    String url = 'https://www.omdbapi.com/?apikey=$apiKey&t=$searchCriteria';
    late MovieDetails movieDetails;

    try {
      var response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);
        //return jsonMap;
        movieDetails = MovieDetails.fromJson(jsonMap);
      }
    } catch (exception) {
      // ignore: avoid_print
      print(exception);
    }
    return movieDetails;
  }
}
