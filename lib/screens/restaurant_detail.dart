import 'package:flutter/material.dart';
import 'package:restaurant_app/model/local_restaurant.dart';
import 'package:restaurant_app/utils/parse.dart';
import 'package:restaurant_app/widget/detail_restaurant_menu.dart';

class RestaurantDetail extends StatefulWidget {
  static const routeName = '/restaurant_detail';
  final String articleId;

  const RestaurantDetail({super.key, required this.articleId});

  @override
  State<RestaurantDetail> createState() => _RestaurantDetailState();
}

class _RestaurantDetailState extends State<RestaurantDetail> {
  bool isLoading = true;

  RestaurantElement restaurant = RestaurantElement(
      city: "",
      description: "",
      id: "",
      menus: Menus(drinks: List.empty(), foods: List.empty()),
      name: "",
      pictureId: "",
      rating: 0);

  void restaurantDetail() async {
    var getJson = await DefaultAssetBundle.of(context)
        .loadString('assets/json/local_restaurant.json');

    final List<RestaurantElement> restaurantParse = parseRestaurant(getJson);

    var restaurantDetail = restaurantParse
        .where((restaurant) => restaurant.id == widget.articleId)
        .toList()[0];

    setState(() {
      isLoading = false;
      restaurant = restaurantDetail;
    });
  }

  @override
  void initState() {
    super.initState();
    restaurantDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          shape: ShapeBorder.lerp(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              1)!,
          actions: const [
            SizedBox(
              width: 50,
            )
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: const Center(
              child: Text(
            'Restaurant Detail',
            style: TextStyle(color: Colors.white),
          )),
        ),
        body: SafeArea(
            child: isLoading
                ? const CircularProgressIndicator()
                : SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                            width: double.infinity,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              restaurant.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Theme.of(context).primaryColor,
                                  size: 14,
                                ),
                                Text(
                                  restaurant.city,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Theme.of(context).primaryColor,
                                  size: 14,
                                ),
                                Text(
                                  restaurant.rating.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, top: 15),
                            child: SizedBox(
                              height: 200,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Hero(
                                  tag: restaurant.pictureId,
                                  child: Image.network(
                                    restaurant.pictureId,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          DetailRestaurantMenu(
                              title: "Makanan",
                              restaurant: restaurant.menus.foods),
                          DetailRestaurantMenu(
                              title: "Minuman",
                              restaurant: restaurant.menus.drinks),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, top: 15),
                            child: Text(
                              restaurant.description,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 12),
                              child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                  ),
                                  child: const Text(
                                    "Pesan Sekarang",
                                    style: TextStyle(color: Colors.white),
                                  ))),
                        ]),
                  )));
  }
}
