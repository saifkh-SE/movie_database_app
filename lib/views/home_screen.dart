import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:movie_database_app/backend/api_manager.dart';
import 'package:movie_database_app/cubit/loading_cubit.dart';
import 'package:movie_database_app/cubit/page_number_cubit.dart';
import 'package:movie_database_app/main.dart';
import 'package:movie_database_app/models/MovieDetails.dart';
import 'package:movie_database_app/models/MovieListItem.dart';
import 'package:movie_database_app/views/movie_details_screen.dart';

String queryText = 'Batman';

class HomeScreen extends StatefulWidget {
  List<MovieListItems> list;
  // String queryText = 'Batman';
  HomeScreen(this.list, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Database'),
        actions: [
          IconButton(
            onPressed: () {
              // method to show the search bar
              showSearch(
                  context: context,
                  // delegate to customize the search bar
                  delegate: CustomSearchDelegate(widget.list));
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            icon: Icon(MyApp.themeNotifier.value == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              MyApp.themeNotifier.value =
                  MyApp.themeNotifier.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
            },
          ),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!context.read<LoadingCubit>().isLoading &&
              (scrollInfo.metrics.pixels / scrollInfo.metrics.maxScrollExtent) >= 0.7) {
            context.read<LoadingCubit>().isLoading = true;

            setState(() {
              Future.delayed(const Duration(seconds: 0), () async {
                List<MovieListItems> list = <MovieListItems>[];
                list =
                    await APIManager().getMoviesList(queryText, context.read<PageNumberCubit>().pageNum + 1);

                if (list.isNotEmpty) {
                  context.read<PageNumberCubit>().pageNum += 1;
                  widget.list.addAll(list);
                }

                context.read<LoadingCubit>().isLoading = false;
              });
            });

            return true;
          }
          return false;
        },
        child: widget.list.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: widget.list.length,
                itemBuilder: (context, index) {
                  // var movies = snapshot.data?.search;
                  // if (_sortOption == 'name') {
                  //   jobs.sort((a, b) {
                  //     return a.title!.compareTo(b.title!);
                  //   });
                  // } else if (_sortOption == 'salary') {
                  //   jobs.sort((a, b) {
                  //     return b.salary!.compareTo(a.salary!);
                  //   });
                  // }
                  // snapshot.data!.jobs!.sort(name(jobs[index].title!));
                  return InkWell(
                    onTap: () async {
                      MovieDetails movieDetails =
                          await APIManager().getMoviesDetails(widget.list[index].title ?? '');
                      Get.to(MovieDetailsScreen(
                        title: movieDetails.title,
                        moviePoster: movieDetails.poster,
                        year: movieDetails.year,
                        description: movieDetails.plot,
                        cast: movieDetails.actors,
                        type: movieDetails.type,
                        rating: movieDetails.rated,
                        imdbRating: movieDetails.imdbRating,
                      ));
                    },
                    child: Container(
                      height: mediaQuery.size.height * 0.12,
                      margin: const EdgeInsets.all(8),
                      child: Row(
                        children: <Widget>[
                          Image.network(
                            widget.list[index].poster ?? '',
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.list[index].title ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: mediaQuery.size.height * 0.02,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.list[index].type ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: mediaQuery.size.height * 0.018,
                                  ),
                                ),
                                const Divider(height: 2),
                                Text(
                                  widget.list[index].year ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: mediaQuery.size.height * 0.016,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  // Demo list to show querying
  List<MovieListItems> list = [];

  CustomSearchDelegate(this.list);

  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
          matchQuery = <MovieListItems>[];
          list = <MovieListItems>[];
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  List<MovieListItems> matchQuery = [];

  Future<void> getMovieList() async {
    list = await APIManager().getMoviesList(query, 1);
    for (var movieTitle in list) {
      if (movieTitle.title!.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(movieTitle);
      }
    }
    queryText = query;
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    getMovieList();

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return InkWell(
          onTap: () async {
            MovieDetails movieDetails = await APIManager().getMoviesDetails(result.title ?? '');
            Get.to(MovieDetailsScreen(
              title: movieDetails.title,
              moviePoster: movieDetails.poster,
              year: movieDetails.year,
              description: movieDetails.plot,
              cast: movieDetails.actors,
              type: movieDetails.type,
              rating: movieDetails.rated,
              imdbRating: movieDetails.imdbRating,
            ));
          },
          child: Container(
            height: Get.height * 0.12,
            margin: const EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Image.network(
                  result.poster ?? '',
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        result.title ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: Get.height * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        result.type ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: Get.height * 0.018,
                        ),
                      ),
                      const Divider(height: 2),
                      Text(
                        result.year ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: Get.height * 0.016,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    getMovieList();

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return InkWell(
          onTap: () async {
            MovieDetails movieDetails = await APIManager().getMoviesDetails(result.title ?? '');
            Get.to(MovieDetailsScreen(
              title: movieDetails.title,
              moviePoster: movieDetails.poster,
              year: movieDetails.year,
              description: movieDetails.plot,
              cast: movieDetails.actors,
              type: movieDetails.type,
              rating: movieDetails.rated,
              imdbRating: movieDetails.imdbRating,
            ));
          },
          child: Container(
            height: Get.height * 0.12,
            margin: const EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Image.network(
                  result.poster ?? '',
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        result.title ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: Get.height * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        result.type ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: Get.height * 0.018,
                        ),
                      ),
                      const Divider(height: 2),
                      Text(
                        result.year ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: Get.height * 0.016,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
