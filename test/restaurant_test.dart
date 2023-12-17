import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:restaurant_app/data/model/restaurant_detail.dart';
import 'restaurant_test.mocks.dart' as mock;

@GenerateMocks([ApiService])
void main() {
  final apiService = mock.MockApiService();

  group('fetchRestaurant', () {
    final responseSearch = jsonEncode({
      "error": false,
      "founded": 1,
      "restaurants": [
        {
          "id": "fnfn8mytkpmkfw1e867",
          "name": "Makan mudah",
          "description":
              "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, ...",
          "pictureId": "22",
          "city": "Medan",
          "rating": 3.7
        }
      ]
    });
    test('return search restaurant by query', () async {
      when(apiService.searchRestaurant("makan")).thenAnswer(
          (_) async => Restaurant.fromJson(jsonDecode(responseSearch)));
      expect(await ApiService().searchRestaurant("makan"), isA<Restaurant>());
    });

    final detailRestaurantRes = {
      "error": false,
      "message": "success",
      "restaurant": {
        "id": "rqdv5juczeskfw1e867",
        "name": "Melting Pot",
        "description":
            "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. ...",
        "city": "Medan",
        "address": "Jln. Pandeglang no 19",
        "pictureId": "14",
        "categories": [
          {"name": "Italia"},
          {"name": "Modern"}
        ],
        "menus": {
          "foods": [
            {"name": "Paket rosemary"},
            {"name": "Toastie salmon"}
          ],
          "drinks": [
            {"name": "Es krim"},
            {"name": "Sirup"}
          ]
        },
        "rating": 4.2,
        "customerReviews": [
          {
            "name": "Ahmad",
            "review": "Tidak rekomendasi untuk pelajar!",
            "date": "13 November 2019"
          }
        ]
      }
    };

    test("return restaurant detail", () async {
      when(apiService.restaurantDetail("rqdv5juczeskfw1e867")).thenAnswer(
          (_) async => RestaurantDetailModel.fromJson(detailRestaurantRes));
      expect(await ApiService().restaurantDetail("rqdv5juczeskfw1e867"),
          isA<RestaurantDetailModel>());
    });
  });
}
