import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/constant/colors.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/providers/favorite_provider.dart';
import 'package:restaurant_app/providers/restaurant_detail_provider.dart';
import 'package:restaurant_app/providers/restaurant_provider.dart';
import 'package:restaurant_app/screens/favorite_restaurant.dart';
import 'package:restaurant_app/screens/home.dart';
import 'package:restaurant_app/screens/restaurant_detail.dart';
import 'package:restaurant_app/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: const MaterialColor(0xFF32B768, {
            50: Color(0xFFF5FCF8),
            100: Color(0xFFEBF8F0),
            200: Color(0xFFCCEDDA),
            300: Color(0xFFABE2C2),
            400: Color(0xFF70CD96),
            500: Color(0xFF32B768),
            600: Color(0xFF2DA35D),
            700: Color(0xFF1E6E3F),
            800: Color(0xFF17532F),
            900: Color(0xFF0F361F),
          }),
          brightness: Brightness.light,
          backgroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: materialColor.shade500,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': ((context) => const SplashScreen()),
        '/home': (context) => ChangeNotifierProvider(
            create: (_) => RestaurantProvider(apiService: ApiService()),
            child: const Home()),
        '/favorite': (context) => ChangeNotifierProvider(
              create: (_) => FavouriteProvider(),
              child: FavoriteRestaurant(),
            ),
        RestaurantDetail.routeName: (context) => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                    create: (_) => RestaurantDetailProvider(
                        apiService: ApiService(),
                        id: ModalRoute.of(context)!.settings.arguments
                            as String)),
                ChangeNotifierProvider(
                    create: (_) =>
                        RestaurantProvider(apiService: ApiService())),
                ChangeNotifierProvider(create: (_) => FavouriteProvider()),
              ],
              child: RestaurantDetail(
                articleId: ModalRoute.of(context)!.settings.arguments as String,
              ),
            )
      },
    );
  }
}
