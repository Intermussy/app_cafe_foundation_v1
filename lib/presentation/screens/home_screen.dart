import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.color});

  final Color color;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: widget.color, title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 24),
            goToStoreButton(context),
            SizedBox(height: 24),
            goToProfileButton(context),
            SizedBox(height: 24),
            goToCartButton(context),
            SizedBox(height: 24),
            goToDrinkDetailButton(context),
            SizedBox(height: 24),
            goToOrderReceiptButton(context),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  MaterialButton goToStoreButton(BuildContext context) {
    return MaterialButton(
      color: Colors.red,
      child: Text('Go to Store', style: TextStyle(color: Colors.white)),
      onPressed: () {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/storemenu', (route) => false);
      },
    );
  }

  MaterialButton goToProfileButton(BuildContext context) {
    return MaterialButton(
      color: Colors.blue,
      child: Text('Go to Profile', style: TextStyle(color: Colors.white)),
      onPressed: () {
        Navigator.of(context).pushNamed('/profile');
      },
    );
  }

  MaterialButton goToCartButton(BuildContext context) {
    return MaterialButton(
      color: Colors.green,
      child: Text('Go to Cart', style: TextStyle(color: Colors.white)),
      onPressed: () {
        Navigator.of(context).pushNamed('/shoppingcart');
      },
    );
  }

  MaterialButton goToDrinkDetailButton(BuildContext context) {
    return MaterialButton(
      color: Colors.orange,
      child: Text('Go to Drink Detail', style: TextStyle(color: Colors.white)),
      onPressed: () {
        Navigator.of(context).pushNamed('/drinkdetail');
      },
    );
  }

  MaterialButton goToOrderReceiptButton(BuildContext context) {
    return MaterialButton(
      color: Colors.orange,
      child: Text('Go to Order Receipt', style: TextStyle(color: Colors.white)),
      onPressed: () {
        Navigator.of(context).pushNamed('/orderreceipt');
      },
    );
  }
}
