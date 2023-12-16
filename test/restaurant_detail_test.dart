import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/data/api/api_service.dart';

void main() {
  ApiService apiService = ApiService();

  String id = 'rqdv5juczeskfw1e867';

  group("get restaurant detail : ", () {
    test('should return restaurant detail', () async {
      var restaurant = await apiService.restaurantDetail(id);
      expect(restaurant.restaurant.id, id);
    });

    test('should return restaurant detail', () async {
      var restaurant = await apiService.restaurantDetail(id);
      expect(restaurant.restaurant.name, 'Melting Pot');
    });

    test("show error when id is not found", () async {
      try {
        await apiService.restaurantDetail('a');
      } catch (e) {
        expect(e, isException);
      }
    });
  });
}
