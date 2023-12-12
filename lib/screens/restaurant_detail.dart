import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/constant/urls.dart';
import 'package:restaurant_app/providers/restaurant_detail_provider.dart';
import 'package:restaurant_app/providers/restaurant_provider.dart';
import 'package:restaurant_app/widget/detail_restaurant_menu.dart';
import 'package:restaurant_app/widget/restaurant_review.dart';

class RestaurantDetail extends StatefulWidget {
  static const routeName = '/restaurant_detail';
  final String articleId;

  const RestaurantDetail({super.key, required this.articleId});

  @override
  State<RestaurantDetail> createState() => _RestaurantDetailState();
}

class _RestaurantDetailState extends State<RestaurantDetail> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
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
        body: SafeArea(child:
            Consumer<RestaurantDetailProvider>(builder: (context, value, _) {
          if (value.state == RestaurantDetailResult.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (value.state == RestaurantDetailResult.hasData) {
            return SingleChildScrollView(
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
                        value.restaurantDetail.restaurant.name,
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
                            value.restaurantDetail.restaurant.city,
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
                            value.restaurantDetail.restaurant.rating.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 12, right: 12, top: 15),
                      child: SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Hero(
                            tag: value.restaurantDetail.restaurant.pictureId,
                            child: Image.network(
                              imageMedium +
                                  value.restaurantDetail.restaurant.pictureId,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    DetailRestaurantMenu(
                        title: "Categories",
                        restaurant:
                            value.restaurantDetail.restaurant.categories),
                    DetailRestaurantMenu(
                        title: "Makanan",
                        restaurant:
                            value.restaurantDetail.restaurant.menus.foods),
                    DetailRestaurantMenu(
                        title: "Minuman",
                        restaurant:
                            value.restaurantDetail.restaurant.menus.drinks),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 12, right: 12, top: 15),
                      child: Text(
                        value.restaurantDetail.restaurant.description,
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
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text(
                              "Pesan Sekarang",
                              style: TextStyle(color: Colors.white),
                            ))),
                    Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 12, right: 12),
                        child: Row(
                          children: [
                            const Text(
                              "Review",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const Spacer(),
                            Consumer<RestaurantProvider>(
                                builder: (context2, value2, _) {
                              return TextButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) {
                                          double modalHeight =
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.5;
                                          double keyboardHeight =
                                              MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom;

                                          return SizedBox(
                                            height:
                                                modalHeight + keyboardHeight,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Column(children: [
                                                const Text(
                                                  "Berikan Review",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                TextField(
                                                  controller: _nameController,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 20,
                                                            vertical: 16),
                                                    hintText: 'Nama',
                                                    hintStyle: const TextStyle(
                                                        color: Colors.black),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                    filled: true,
                                                    fillColor: Colors.grey[200],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                TextField(
                                                  controller: _reviewController,
                                                  maxLines: 4,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 20,
                                                            vertical: 16),
                                                    hintText: 'Review',
                                                    hintStyle: const TextStyle(
                                                        color: Colors.black),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                    filled: true,
                                                    fillColor: Colors.grey[200],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      var res =
                                                          await value.addReview(
                                                              widget.articleId,
                                                              _nameController
                                                                  .text,
                                                              _reviewController
                                                                  .text);

                                                      value2.isReviewedThisRestaurant =
                                                          widget.articleId;

                                                      if (res ==
                                                          AddReviewResult
                                                              .success) {
                                                        showSnackBar(
                                                            "Berhasil menambahkan review");
                                                      } else {
                                                        showSnackBar(
                                                            "Gagal menambahkan review");
                                                      }
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      minimumSize: const Size(
                                                          double.infinity, 50),
                                                    ),
                                                    child: Text(
                                                      value.state ==
                                                              RestaurantDetailResult
                                                                  .isLoading
                                                          ? "Loading"
                                                          : "Kirim",
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ))
                                              ]),
                                            ),
                                          );
                                        });
                                  },
                                  child: value2.isReviewed
                                          .contains(widget.articleId)
                                      ? const SizedBox()
                                      : const Text(
                                          "Tambah Review",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 12),
                                        ));
                            })
                          ],
                        )),
                    RestaurantReview(
                        customerReview:
                            value.restaurantDetail.restaurant.customerReviews)
                  ]),
            );
          } else {
            return const Center(
              child: Text("Error"),
            );
          }
        })));
  }
}
