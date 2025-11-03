import 'dart:async';

import 'package:app_foundation/features/store_menu/repositories/database_provider.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initDB();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, '/storemenu');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 11, 54, 88),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlutterLogo(size: 120),
              SizedBox(height: 16),
              CircularProgressIndicator(color: Colors.orange),
            ],
          ),
        ),
      ),
    );
  }

  void initDB() async {
    await DatabaseProvider.deleteDatabaseFile();
    await DatabaseProvider.database;
  }
}
