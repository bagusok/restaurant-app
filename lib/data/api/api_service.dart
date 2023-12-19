import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:restaurant_app/data/model/restaurant_detail.dart';
import 'package:restaurant_app/data/model/restaurant_review.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';

  late http.Client client;

  ApiService(http.Client? client) {
    if (client == null) {
      this.client = http.Client();
    } else {
      this.client = client;
    }
  }

  Future<Restaurant> searchRestaurant(String query) async {
    try {
      final response =
          await client.get(Uri.parse("${_baseUrl}search?q=$query"));

      if (response.statusCode == 200) {
        return restaurantFromJson(response.body);
      } else {
        throw Exception('Failed to load restaurant');
      }
    } catch (err) {
      throw Exception('Please check your internet connection');
    }
  }

  Future<RestaurantDetailModel> restaurantDetail(String id) async {
    try {
      final response = await client.get(Uri.parse("${_baseUrl}detail/$id"));

      if (response.statusCode == 200) {
        return restaurantDetailFromJson(response.body);
      } else {
        throw Exception('Failed to load restaurant');
      }
    } catch (err) {
      throw Exception('Please check your internet connection');
    }
  }

  Future<RestaurantReviewModel> addReview(
      String id, String name, String review) async {
    try {
      final response = await client.post(
        Uri.parse("${_baseUrl}review"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'id': id, 'name': name, 'review': review}),
      );

      var parsedJson = restaurantReviewModelFromJson(response.body);

      if (parsedJson.error == false) {
        return parsedJson;
      } else {
        throw Exception('Failed to add review');
      }
    } catch (err) {
      throw Exception('Please check your internet connection');
    }
  }
}
