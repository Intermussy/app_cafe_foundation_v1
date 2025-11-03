import 'package:app_foundation/features/store_menu/models/drink_cart_model.dart';
import 'package:app_foundation/features/store_menu/models/adapters/drink_source.dart';
import 'package:app_foundation/features/store_menu/views/cart/cart_list_page.dart';
import 'package:app_foundation/features/store_menu/views/drink_customization/drink_detail_page.dart';
import 'package:app_foundation/features/store_menu/views/receipt/order_receipt_page.dart';
import 'package:app_foundation/features/store_menu/views/catalog/store_main_page.dart';
import 'package:app_foundation/features/store_menu/views/splash_page.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute<DrinkCartModel>(builder: (_) => SplashPage());
      case '/storemenu':
        return MaterialPageRoute(builder: (_) => StoreMainMenu());
      case '/shoppingcart':
        return MaterialPageRoute(builder: (_) => CartListPage());
      case '/drinkdetail':
        final (source, isEdit) = settings.arguments as (DrinkSource, bool);
        return MaterialPageRoute<DrinkCartModel>(
          builder: (_) => DrinkDetailPage(source: source, isEdit: isEdit),
        );
      case '/orderreceipt':
        final dcm = settings.arguments as List<DrinkCartModel>;
        return MaterialPageRoute(builder: (_) => OrderReceiptPage(drinks: dcm));
      default:
        return null;
    }
  }
}
