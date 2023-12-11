import 'package:flutter/material.dart';
import 'package:restaurant_app/model/local_restaurant.dart';
import 'package:restaurant_app/screens/restaurant_detail.dart';

class RestaurantItem extends StatelessWidget {
  final RestaurantElement item;

  const RestaurantItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: ListTile(
          onTap: () {},
          leading: SizedBox(
            width: 70,
            height: 70,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Hero(
                tag: item.pictureId,
                child: Image.network(
                  item.pictureId,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          title: Text(
            item.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(children: [
            const SizedBox(
              height: 8,
            ),
            Row(children: [
              const Icon(Icons.location_pin, size: 17),
              Text(
                item.city,
                style: const TextStyle(fontSize: 12),
              ),
            ]),
            const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  size: 18,
                ),
                Text(
                  item.rating.toString(),
                  style: const TextStyle(fontSize: 12),
                )
              ],
            )
          ]),
          trailing: ElevatedButton(
              child: const Text(
                "Detail",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pushNamed(context, RestaurantDetail.routeName,
                    arguments: item.id);
              })),
    );
  }
}
