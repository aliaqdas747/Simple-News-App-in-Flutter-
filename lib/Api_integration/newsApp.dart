import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'NewsModel.dart';

class Newsapp extends StatefulWidget {
  const Newsapp({super.key});

  @override
  State<Newsapp> createState() => _NewsappState();
}

class _NewsappState extends State<Newsapp> {
  late Future<NewsModel> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = fetchNews();
  }

  Future<NewsModel> fetchNews() async {
    final url =
        'https://newsapi.org/v2/everything?q=tesla&from=2024-12-05&sortBy=publishedAt&apiKey=3af57bfc2d84479392e8c91d74dbe179';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return NewsModel.fromJson(result);
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
        centerTitle: true,
      ),
      body: FutureBuilder<NewsModel>(
        future: futureNews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.articles == null || snapshot.data!.articles!.isEmpty) {
            return Center(child: Text('No news articles found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.articles!.length,
              itemBuilder: (context, index) {
                final article = snapshot.data!.articles![index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display the image
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                        child: Image.network(
                          article.urlToImage ?? 'https://via.placeholder.com/150', // Placeholder if image is null
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              article.title ?? '',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            // Description
                            Text(
                              article.description ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8),
                            // Published date
                            Text(
                              article.publishedAt ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}