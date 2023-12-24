import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/urls.dart';
import 'package:restaurant_app/providers/favorite_provider.dart';
import 'package:restaurant_app/screens/restaurant_detail.dart';

class FavoriteRestaurant extends StatefulWidget {
  const FavoriteRestaurant({Key? key}) : super(key: key);

  @override
  State<FavoriteRestaurant> createState() => _FavoriteRestaurantState();
}

class _FavoriteRestaurantState extends State<FavoriteRestaurant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Favorite Restaurant'),
          leading: IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/home", (route) => false);
            },
            icon: const Icon(Icons.arrow_back),
          )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<FavouriteProvider>(builder: (context, value, _) {
          if (value.state == FavoriteState.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (value.state == FavoriteState.hasData) {
            return ListView.builder(
              itemCount: value.favouriteList.length,
              itemBuilder: (context, index) {
                final restaurant = value.favouriteList[index];
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, RestaurantDetail.routeName,
                          arguments: {
                            "restaurant_id": restaurant.id,
                            "fromPage": "favorite"
                          });
                    },
                    leading: Image.network(
                      imageMedium + restaurant.pictureId,
                      width: 100,
                    ),
                    title: Text(restaurant.name),
                    subtitle: Text(restaurant.city),
                    trailing: IconButton(
                      onPressed: () {
                        // value.removeRestaurant(restaurant.id);
                        Provider.of<FavouriteProvider>(context, listen: false)
                            .removeRestaurant(restaurant.id);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('No data'),
            );
          }
        }),
      ),
    );
  }
}
