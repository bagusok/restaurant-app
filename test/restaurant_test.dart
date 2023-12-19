import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:restaurant_app/data/model/restaurant_detail.dart';
import 'package:http/http.dart' as http;
import 'restaurant_test.mocks.dart' as mock;

@GenerateMocks([http.Client])
void main() {
  final httpClient = mock.MockClient();
  final ApiService apiService = ApiService(httpClient);

  group("Test Restaurant Restaurant detail", () {
    test("Return Restaurant Detail", () async {
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
      when(httpClient.get(Uri.parse(
              'https://restaurant-api.dicoding.dev/detail/rqdv5juczeskfw1e867')))
          .thenAnswer(
              (_) async => http.Response(jsonEncode(detailRestaurantRes), 200));

      expect(await apiService.restaurantDetail("rqdv5juczeskfw1e867"),
          isA<RestaurantDetailModel>());
    });

    test('throws an exception if the http call completes with an error', () {
      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(httpClient.get(Uri.parse(
              'https://restaurant-api.dicoding.dev/detail/rqdv5juczeskfw1e867')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(
          apiService.restaurantDetail("rqdv5juczeskfw1e867"), throwsException);
    });
  });

  group("Test Search Restaurant", () {
    test("Return Search Restaurant", () async {
      final searchRestaurantRes = {
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
      };
      when(httpClient.get(Uri.parse(
              'https://restaurant-api.dicoding.dev/search?q=makan%20mudah')))
          .thenAnswer(
              (_) async => http.Response(jsonEncode(searchRestaurantRes), 200));

      expect(
          await apiService.searchRestaurant("makan mudah"), isA<Restaurant>());
    });

    test('throws an exception if the http call completes with an error', () {
      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(httpClient.get(Uri.parse(
              'https://restaurant-api.dicoding.dev/search?q=makan%20mudah')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(apiService.searchRestaurant('makan mudah'), throwsException);
    });
  });
}
