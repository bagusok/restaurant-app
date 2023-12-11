import 'package:flutter/material.dart';
import 'package:restaurant_app/constant/urls.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_detail.dart';
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
  bool isLoading = true;

  late RestaurantDetailModel _restaurantDetail;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();

  Future<void> getRestaurantDetail() async {
    var getJson = await ApiService().restaurantDetail(widget.articleId);

    setState(() {
      isLoading = false;
      _restaurantDetail = getJson;
    });
  }

  Future<void> addReview(String id, String name, String review) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (name.isEmpty || review.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nama dan Review tidak boleh kosong"),
        ),
      );
      return;
    }

    var getJson = await ApiService().addReview(id, name, review);

    if (getJson.error == false) {
      _restaurantDetail.restaurant.customerReviews.clear();
      _restaurantDetail.restaurant.customerReviews.addAll(
          getJson.customerReviews.map((e) =>
              CustomerReview(name: e.name, review: e.review, date: e.date)));
      _nameController.clear();
      _reviewController.clear();
      setState(() {});

      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text("Berhasil menambahkan review"),
        ),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text("Gagal menambahkan review"),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getRestaurantDetail();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
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
                              _restaurantDetail.restaurants.name,
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
                                  _restaurantDetail.restaurants.city,
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
                                  _restaurantDetail.restaurant.rating
                                      .toString(),
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
                                  tag: _restaurantDetail.restaurant.rating,
                                  child: Image.network(
                                    imageMedium +
                                        _restaurantDetail.restaurant.pictureId,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          DetailRestaurantMenu(
                              title: "Categories",
                              restaurant:
                                  _restaurantDetail.restaurant.categories),
                          DetailRestaurantMenu(
                              title: "Makanan",
                              restaurant:
                                  _restaurantDetail.restaurant.menus.foods),
                          DetailRestaurantMenu(
                              title: "Minuman",
                              restaurant:
                                  _restaurantDetail.restaurant.menus.drinks),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, top: 15),
                            child: Text(
                              _restaurantDetail.restaurant.description,
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
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 12, right: 12),
                              child: Row(
                                children: [
                                  const Text(
                                    "Review",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  const Spacer(),
                                  TextButton(
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
                                                height: modalHeight +
                                                    keyboardHeight,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(12),
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
                                                      controller:
                                                          _nameController,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 20,
                                                                vertical: 16),
                                                        hintText: 'Nama',
                                                        hintStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .black),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                          borderSide:
                                                              BorderSide.none,
                                                        ),
                                                        filled: true,
                                                        fillColor:
                                                            Colors.grey[200],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    TextField(
                                                      controller:
                                                          _reviewController,
                                                      maxLines: 4,
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 20,
                                                                vertical: 16),
                                                        hintText: 'Review',
                                                        hintStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .black),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                          borderSide:
                                                              BorderSide.none,
                                                        ),
                                                        filled: true,
                                                        fillColor:
                                                            Colors.grey[200],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          addReview(
                                                              widget.articleId,
                                                              _nameController
                                                                  .text,
                                                              _reviewController
                                                                  .text);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          minimumSize:
                                                              const Size(
                                                                  double
                                                                      .infinity,
                                                                  50),
                                                        ),
                                                        child: const Text(
                                                          "Kirim Review",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ))
                                                  ]),
                                                ),
                                              );
                                            });
                                      },
                                      child: const Text("Tambah Review",
                                          style:
                                              TextStyle(color: Colors.green)))
                                ],
                              )),
                          RestaurantReview(
                              customerReview:
                                  _restaurantDetail.restaurant.customerReviews)
                        ]),
                  )));
  }
}
