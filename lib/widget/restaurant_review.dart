import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant_detail.dart';

class RestaurantReview extends StatelessWidget {
  final List<CustomerReview> customerReview;

  const RestaurantReview({
    super.key,
    required this.customerReview,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: customerReview
              .map(
                (item) => Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 10),
                  width: MediaQuery.of(context).size.width - 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.8),
                    ),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(item.review),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          item.date,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ]),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
