import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:restaurant_app/providers/restaurant_provider.dart';
import 'package:restaurant_app/widget/restaurant_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var restaurants = <RestaurantElement>[];
  bool isLoading = true;

  TextEditingController searchQuery = TextEditingController();

  @override
  void initState() {
    super.initState();
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
                          Consumer<RestaurantProvider>(
                              builder: (context, value, _) {
                            return TextField(
                              controller: searchQuery,
                              onEditingComplete: () =>
                                  value.searchRestaurant = searchQuery.text,
                              onChanged: (values) {
                                if (values == "") {
                                  value.searchRestaurant = "";
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
                            );
                          }),
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
                      child: Consumer<RestaurantProvider>(
                          builder: (context, state, _) {
                        if (state.state == ResultState.isLoading) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else if (state.state == ResultState.hasData) {
                          return ListView.builder(
                            itemBuilder: (context, index) {
                              return RestaurantItem(
                                item: state.restaurants[index],
                              );
                            },
                            itemCount: state.restaurants.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                          );
                        } else if (state.state == ResultState.error) {
                          return const Center(
                            child: Text("Error, Please check your connection"),
                          );
                        } else {
                          return const Center(
                            child: Text("Tidak Ada Restoran"),
                          );
                        }
                      }),
                    )
                  ],
                ),
              ))),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
