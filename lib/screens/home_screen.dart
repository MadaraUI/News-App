import 'package:flutter/material.dart';
import 'package:mad_news/model/category_data.dart';
import 'package:mad_news/screens/category_news.dart';
import 'package:mad_news/screens/news_detail.dart';
import 'package:mad_news/services/services.dart';
import 'package:mad_news/screens/bookmark_news.dart';
import '../model/new_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<NewsModel> articles = [];
  List<CategoryModel> categories = [];
  List<NewsModel> bookmarkedArticles = []; 
  bool isLoadin = true;
  String searchText = "";

  Map<int, String> reactions = {};

  getNews() async {
    NewsApi newsApi = NewsApi();
    await newsApi.getNews();
    articles = newsApi.dataStore;
    setState(() {
      isLoadin = false;
    });
  }

  @override
  void initState() {
    categories = getCategories();
    getNews();
    super.initState();
  }

  void setReaction(int index, String reaction) {
    setState(() {
      reactions[index] = reaction;
    });
  }

  void toggleBookmark(NewsModel article) {
    setState(() {
      if (bookmarkedArticles.contains(article)) {
        bookmarkedArticles.remove(article);
      } else {
        bookmarkedArticles.add(article);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News App", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
             icon: Icon(
    Icons.bookmark,
    color: Colors.blue.shade900, 
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookmarkNewsScreen(
          bookmarkedArticles: bookmarkedArticles,
          onDelete: (article) {
            setState(() {
              bookmarkedArticles.remove(article);
            });
          },
        ),
      ),
    );
  },
          ),
        ],
      ),
      body: isLoadin
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Category Selection Section
                  Container(
                    height: 55,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                      itemCount: categories.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SelectedCategoryNews(
                                  category: category.categoryName!,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blue.shade900,
                              ),
                              child: Center(
                                child: Text(
                                  category.categoryName!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Search Bar Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchText = value.toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Search News",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Top News",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ),
                  ),

                  // News Section with Bookmark Feature
                  ListView.builder(
                    itemCount: articles.length,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      if (article.title!.toLowerCase().contains(searchText)) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDetail(newsModel: article),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    article.urlToImage!,
                                    height: 250,
                                    width: 400,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  article.title!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const Divider(thickness: 2),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            reactions[index] == 'like'
                                                ? Icons.thumb_up
                                                : Icons.thumb_up_off_alt,
                                            color: reactions[index] == 'like'
                                                ? Colors.blue.shade900
                                                : Colors.grey,
                                          ),
                                          onPressed: () {
                                            setReaction(index, 'like');
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            reactions[index] == 'heart'
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: reactions[index] == 'heart'
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                          onPressed: () {
                                            setReaction(index, 'heart');
                                          },
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        bookmarkedArticles.contains(article)
                                            ? Icons.bookmark
                                            : Icons.bookmark_border,
                                        color: bookmarkedArticles.contains(article)
                                            ? Colors.blue.shade900
                                            : Colors.grey,
                                      ),
                                      onPressed: () {
                                        toggleBookmark(article);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }
}



