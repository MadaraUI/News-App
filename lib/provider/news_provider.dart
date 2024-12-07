import 'package:flutter/material.dart';
import 'package:mad_news/model/new_model.dart';
import 'package:mad_news/services/services.dart';
import 'package:mad_news/model/category_data.dart';

class NewsProvider with ChangeNotifier {
  List<NewsModel> _articles = [];
  List<CategoryModel> _categories = [];
  bool _isLoading = true;

  List<NewsModel> get articles => _articles;
  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;

  NewsProvider() {
    _categories = getCategories(); 
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      _isLoading = true;
      notifyListeners();

      final newsApi = NewsApi(); 
      await newsApi.getNews();   
      _articles = newsApi.dataStore; 

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error fetching news: $error');
    }
  }
}
