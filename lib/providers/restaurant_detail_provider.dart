import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_detail.dart';

enum RestaurantDetailResult { isLoading, noData, hasData, error }

enum AddReviewResult { success, error, isLoading }

class RestaurantDetailProvider with ChangeNotifier {
  RestaurantDetailModel _restaurantDetail = RestaurantDetailModel(
      error: true,
      message: "",
      restaurant: RestaurantDetailElement(
          id: "",
          name: "",
          description: "",
          city: "",
          address: "",
          pictureId: "",
          categories: [],
          menus: Menus(foods: [], drinks: []),
          rating: 0,
          customerReviews: []));
  RestaurantDetailModel get restaurantDetail => _restaurantDetail;

  RestaurantDetailResult _state = RestaurantDetailResult.isLoading;
  RestaurantDetailResult get state => _state;
  final ApiService apiService;

  RestaurantDetailProvider({required this.apiService, String? id}) {
    if (id != null) {
      getRestaurantById(id);
    } else {
      _state = RestaurantDetailResult.error;
      notifyListeners();
    }
  }

  Future<void> getRestaurantById(String id) async {
    _state = RestaurantDetailResult.isLoading;
    notifyListeners();

    try {
      var response = await apiService.restaurantDetail(id);
      if (response.error) {
        _state = RestaurantDetailResult.noData;
        _restaurantDetail = response;
        notifyListeners();
      } else {
        _restaurantDetail = response;
        _state = RestaurantDetailResult.hasData;
        notifyListeners();
      }
    } catch (e) {
      _state = RestaurantDetailResult.error;
      notifyListeners();
    }
  }

  Future<AddReviewResult> addReview(
      String id, String name, String review) async {
    try {
      var response = await apiService.addReview(id, name, review);
      if (response.error) {
        _state = RestaurantDetailResult.noData;

        notifyListeners();
        return AddReviewResult.error;
      } else {
        _restaurantDetail.restaurant.customerReviews.clear();
        _restaurantDetail.restaurant.customerReviews.addAll(
            response.customerReviews.map((e) =>
                CustomerReview(name: e.name, review: e.review, date: e.date)));
        _state = RestaurantDetailResult.hasData;
        notifyListeners();

        return AddReviewResult.success;
      }
    } catch (e) {
      _state = RestaurantDetailResult.error;
      notifyListeners();
      return AddReviewResult.error;
    }
  }
}
