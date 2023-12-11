import 'package:flutter/material.dart';
import 'package:restaurant_app/model/local_restaurant.dart';
import 'package:restaurant_app/utils/parse.dart';
import 'package:restaurant_app/widget/restaurant_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var restaurants = <RestaurantElement>[];
  TextEditingController searchQuery = TextEditingController();

  void searchRestaurant() async {
    var getJson = await DefaultAssetBundle.of(context)
        .loadString('assets/json/local_restaurant.json');

    final List<RestaurantElement> restaurantParse = parseRestaurant(getJson);

    var restaurant = restaurantParse
        .where((restaurant) => restaurant.name
            .toLowerCase()
            .contains(searchQuery.text.toLowerCase()))
        .toList();

    if (restaurant.isEmpty) {
      setState(() {
        restaurants.clear();
      });
    } else {
      setState(() {
        restaurants = restaurant;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    searchRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ),
        title: const Center(
          child: Text(
            'Restaurant App',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Image.asset('assets/images/user-icon.png',
                  width: 24, height: 24))
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      height: 50,
                      child: Stack(
                        children: [
                          TextField(
                            controller: searchQuery,
                            onEditingComplete: () => searchRestaurant(),
                            onChanged: (value) {
                              if (value == "") {
                                searchRestaurant();
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 45),
                              hintText: 'Search',
                              hintStyle: const TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 12, left: 16),
                            child: Icon(
                              Icons.search,
                              color: Colors.black.withOpacity(0.5),
                              size: 24,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 16),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: restaurants
                                .map((item) => RestaurantItem(item: item))
                                .toList())),
                  ],
                ),
              ))),
    );
  }
}
