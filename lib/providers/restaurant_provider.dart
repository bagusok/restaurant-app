import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';

enum ResultState { isLoading, noData, hasData, error }

class RestaurantProvider with ChangeNotifier {
  List<RestaurantElement> _restaurants = [];
  List<RestaurantElement> get restaurants => _restaurants;

  final List _isReviewed = [];

  ResultState? _state;
  ResultState? get state => _state;

  final ApiService apiService;

  RestaurantProvider({required this.apiService, String? id}) {
    _searchRestaurant("");
  }

  Future<List<RestaurantElement>> _searchRestaurant(String query) async {
    _state = ResultState.isLoading;
    notifyListeners();

    try {
      var response = await apiService.searchRestaurant(query);
      if (response.restaurants.isEmpty) {
        _state = ResultState.noData;
        _restaurants = [];
      } else {
        _restaurants = response.restaurants;
        _state = ResultState.hasData;
      }
      notifyListeners();

      return _restaurants;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return [];
    }
  }

  set searchRestaurant(String query) {
    _searchRestaurant(query);
  }

  set isReviewedThisRestaurant(String id) {
    _isReviewed.add(id);
    notifyListeners();
  }

  get isReviewed => _isReviewed;
}
