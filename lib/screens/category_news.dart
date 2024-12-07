
import 'package:flutter/material.dart';
import 'package:mad_news/screens/news_detail.dart';
import 'package:mad_news/services/services.dart';
import '../model/new_model.dart';

class SelectedCategoryNews extends StatefulWidget {
  final String category;
  const SelectedCategoryNews({super.key, required this.category});

  @override
  State<SelectedCategoryNews> createState() => _SelectedCategoryNewsState();
}

class _SelectedCategoryNewsState extends State<SelectedCategoryNews> {
  List<NewsModel> articles = [];
  bool isLoading = true;

  
  final Map<String, List<Map<String, String>>> comments = {};

  final TextEditingController commentController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  void getNews() async {
    CatagoryNews news = CatagoryNews();
    await news.getNews(widget.category);
    articles = news.dataStore;

    
    for (var article in articles) {
      comments[article.title!] = [];
    }

    setState(() {
      isLoading = false;
    });
  }

  void addComment(String title, String username, String comment) {
    setState(() {
      comments[title]?.add({"username": username, "comment": comment});
    });
    usernameController.clear();
    commentController.clear();
  }

  void editComment(String title, int index) {
    usernameController.text = comments[title]![index]["username"]!;
    commentController.text = comments[title]![index]["comment"]!;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Comment"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(hintText: "Edit username"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(hintText: "Edit comment"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  comments[title]![index] = {
                    "username": usernameController.text,
                    "comment": commentController.text,
                  };
                });
                usernameController.clear();
                commentController.clear();
                Navigator.pop(context);
              },
              child: const Text("Update"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void deleteComment(String title, int index) {
    setState(() {
      comments[title]?.removeAt(index);
    });
  }

  @override
  void initState() {
    getNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        title: Text(
          widget.category,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    itemCount: articles.length,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return Container(
                        margin: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NewsDetail(newsModel: article),
                                  ),
                                );
                              },
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
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Comments",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            ListView.builder(
                              itemCount: comments[article.title!]?.length ?? 0,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, commentIndex) {
                                final comment =
                                    comments[article.title!]![commentIndex];
                                return ListTile(
                                  title: Text(comment["comment"]!),
                                  subtitle: Text(
                                    "By: ${comment["username"]}",
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () => editComment(
                                            article.title!, commentIndex),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => deleteComment(
                                            article.title!, commentIndex),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: usernameController,
                                          decoration: const InputDecoration(
                                            hintText: "Enter Your Name",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: commentController,
                                          decoration: const InputDecoration(
                                            hintText: "Add Comment",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
  onPressed: () {
    if (usernameController.text.isNotEmpty &&
        commentController.text.isNotEmpty) {
      addComment(
        article.title!,
        usernameController.text,
        commentController.text,
      );
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue.shade900, 
    foregroundColor: Colors.white, 
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), 
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), 
    ),
  ),
  child: const Text("Post"),
),

                                ],
                              ),
                            ),
                            const Divider(thickness: 2),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}





