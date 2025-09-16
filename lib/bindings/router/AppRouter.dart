import 'package:app_foundation/features/profile/views/profile_page.dart';
import 'package:app_foundation/features/store_menu/views/cart_list_page.dart';
import 'package:app_foundation/features/store_menu/views/store_main_page.dart';
import 'package:app_foundation/presentation/screens/home_screen.dart';
import 'package:app_foundation/presentation/screens/secondscreen.dart';
import 'package:app_foundation/presentation/screens/thirdscreen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) =>
              MyHomePage(title: 'Home Screen', color: Colors.blueAccent),
        );
      case '/second':
        return MaterialPageRoute(
          builder: (_) =>
              SecondScreen(title: "Second Screen", color: Colors.redAccent),
        );
      case '/third':
        return MaterialPageRoute(
          builder: (_) =>
              ThirdScreen(title: "Thirst Screen", color: Colors.greenAccent),
        );
      case '/storemenu':
        return MaterialPageRoute(builder: (_) => StoreMainMenu(title: 'menu'));
      case '/profile':
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case '/shoppingcart':
        return MaterialPageRoute(builder: (_) => CartListPage());

      default:
        return null;
    }
  }
}
