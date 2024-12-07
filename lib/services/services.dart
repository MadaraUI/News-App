import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mad_news/model/new_model.dart';

class NewsApi {
  List<NewsModel> dataStore = [];
  Future<void> getNews() async {
    Uri url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=7848263ced3249a4ac63d29016359b3d");
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    if (jsonData["status"] == 'ok') {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null &&
            element['description'] != null &&
            element['author'] != null &&
            element['content'] != null) {
          NewsModel newsModel = NewsModel(
            title: element['title'], // name must be same fron api
            urlToImage: element['urlToImage'],
            description: element['description'],
            author: element['author'],
            content: element['content'],
          );

          dataStore.add(newsModel);
        }
      });
    }
  }
}


class CatagoryNews {
  List<NewsModel> dataStore = [];
  Future<void> getNews(String category) async {
    Uri url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=7848263ced3249a4ac63d29016359b3d");
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    if (jsonData["status"] == 'ok') {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null &&
            element['description'] != null &&
            element['author'] != null &&
            element['content'] != null) {
          NewsModel newsModel = NewsModel(
            title: element['title'], 
            urlToImage: element['urlToImage'],
            description: element['description'],
            author: element['author'],
            content: element['content'],
          );

          dataStore.add(newsModel);
        }
      });
    }
  }
}
