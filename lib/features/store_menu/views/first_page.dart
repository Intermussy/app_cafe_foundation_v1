import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  FirstPage({super.key});

  final Widget item = Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [Icon(Icons.person), SizedBox(width: 4), Text("something")],
    ),
  );

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerList = [item, item, item];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.edit),
      ),
      appBar: AppBar(),
      endDrawer: SafeArea(
        child: Container(
          width: 300,
          color: Colors.white,
          child: Column(children: drawerList),
        ),
      ),
      drawer: SafeArea(
        child: Container(
          width: 300,
          color: Colors.white,
          child: Column(children: drawerList),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 2, color: Colors.red),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Text..."),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
