import 'package:flutter/material.dart';
import '../model/new_model.dart';

class BookmarkNewsScreen extends StatelessWidget {
  final List<NewsModel> bookmarkedArticles;
  final Function(NewsModel) onDelete;

  const BookmarkNewsScreen({
    super.key,
    required this.bookmarkedArticles,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmarks", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: bookmarkedArticles.isEmpty
          ? const Center(child: Text("No bookmarks yet!"))
          : ListView.builder(
              itemCount: bookmarkedArticles.length,
              itemBuilder: (context, index) {
                final article = bookmarkedArticles[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: article.urlToImage != null
                        ? Image.network(article.urlToImage!, fit: BoxFit.cover, width: 50)
                        : const Icon(Icons.article),
                    title: Text(
                      article.title ?? "No Title",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Trigger the delete function
                        onDelete(article);

                        // Show a confirmation Snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Bookmark removed successfully."),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

