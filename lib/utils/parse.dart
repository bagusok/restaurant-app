import 'dart:convert';

import 'package:restaurant_app/data/model/list_restaurant.dart';

List<RestaurantElement> parseRestaurant(String? json) {
  if (json == null) {
    return [];
  }

  final Map<String, dynamic> parsed = jsonDecode(json);
  final List<dynamic> restaurants = parsed['restaurants'];

  return restaurants.map((json) => RestaurantElement.fromJson(json)).toList();
}

//  Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: restaurants
//                                 .map((item) => RestaurantItem(item: item))
//                                 .toList())
