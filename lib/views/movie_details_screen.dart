import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
// import 'package:html/parser.dart';
// import 'package:url_launcher/url_launcher.dart';

class MovieDetailsScreen extends StatelessWidget {
  final String? title;
  final String? moviePoster;
  final String? year;
  final String? type;
  final String? cast;
  final String? rating;
  final String? imdbRating;
  final String? description;
  final String? url;

  const MovieDetailsScreen({
    Key? key,
    this.title,
    this.moviePoster,
    this.year,
    this.type,
    this.cast,
    this.rating,
    this.imdbRating,
    this.description,
    this.url,
  }) : super(key: key);

  // String _parseHtmlString(String htmlString) {
  //   final document = parse(htmlString);
  //   final String parsedString = parse(document.body!.text).documentElement!.text;
  //   return parsedString;
  // }

  Future<void> share() async {
    await FlutterShare.share(
      title: title ?? '',
      text: title,
      linkUrl: '$moviePoster\n\n' '$description\n\n' '$cast',
      chooserTitle: title,
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? ''),
      ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: mediaQuery.size.height * 0.2,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(15),
                    child: Image.network(
                      moviePoster ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: mediaQuery.size.height * 0.022,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$type - $rating',
                          style: TextStyle(
                            fontSize: mediaQuery.size.height * 0.018,
                          ),
                        ),
                        const Divider(height: 8),
                        Text(
                          'Released: $year',
                          style: TextStyle(
                            fontSize: mediaQuery.size.height * 0.018,
                          ),
                        ),
                        Text(
                          'IMDB Rating: $imdbRating',
                          style: TextStyle(
                            fontSize: mediaQuery.size.height * 0.018,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                  child: Text(
                    'Cast:',
                    style: TextStyle(
                      fontSize: mediaQuery.size.height * 0.018,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                  child: Text(
                    cast ?? '',
                    style: TextStyle(
                      fontSize: mediaQuery.size.height * 0.018,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                  child: Text(
                    'Plot/Description:',
                    style: TextStyle(
                      fontSize: mediaQuery.size.height * 0.018,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                  child: Text(
                    description ?? '',
                    style: TextStyle(
                      fontSize: mediaQuery.size.height * 0.018,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                      child: ElevatedButton(
                          onPressed: () async {
                            // SocialShare.shareFacebookStory(
                            //   moviePoster ?? '',
                            //   'backgroundTopColor',
                            //   'backgroundBottomColor',
                            //   description ?? '',
                            // );
                            share();
                          },
                          child: const Text('Share')),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
