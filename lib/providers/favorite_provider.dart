import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:restaurant_app/utils/db_helper.dart';

enum FavoriteState { isLoading, noData, hasData, error }

class FavouriteProvider with ChangeNotifier {
  List<RestaurantElement> _favouriteList = [];
  List<RestaurantElement> get favouriteList => _favouriteList;

  FavoriteState _state = FavoriteState.hasData;
  FavoriteState get state => _state;

  late DatabaseHelper _dbHelper;

  FavouriteProvider() {
    _dbHelper = DatabaseHelper();
    getFavourite();
  }

  Future<void> getFavourite() async {
    _state = FavoriteState.isLoading;
    notifyListeners();

    final result = await _dbHelper.getRestaurants();
    _favouriteList = result
        .map((e) => RestaurantElement(
            id: e.id,
            name: e.name,
            description: e.description,
            pictureId: e.pictureId,
            city: e.city,
            rating: e.rating))
        .toList();

    if (_favouriteList.isEmpty) {
      _state = FavoriteState.noData;
    } else {
      _state = FavoriteState.hasData;
    }
    notifyListeners();
  }

  Future<void> addFavorite(RestaurantElement restaurant) async {
    await _dbHelper.insertRestaurant(restaurant);
    getFavourite();
  }

  Future<void> removeRestaurant(String id) async {
    await _dbHelper.removeRestaurant(id);
    getFavourite();
  }

  Future<bool> isFavourite(String id) async {
    final result = await _dbHelper.getRestaurantById(id);
    return result.isNotEmpty;
  }
}
