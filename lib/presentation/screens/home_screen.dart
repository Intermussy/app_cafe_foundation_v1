import 'package:app_foundation/cubit/counter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            Text('You have pushed the button this many times:'),
            BlocConsumer<CounterCubit, CounterState>(
              listener: (context, state) {
                if (state.wasIncremented == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Incremented!'),
                      duration: Duration(milliseconds: 300),
                    ),
                  );
                } else if (state.wasIncremented == false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Decremented!'),
                      duration: Duration(milliseconds: 300),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.counterValue < 0) {
                  return Text(
                    'BRR, NEGATIVE ${state.counterValue}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                } else if (state.counterValue % 2 == 0) {
                  return Text(
                    'YAAAY ${state.counterValue}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                } else if (state.counterValue == 5) {
                  return Text(
                    'HMM, NUMBER 5',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                } else {
                  return Text(
                    state.counterValue.toString(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                }
              },
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: Text(widget.title),
                  onPressed: () {
                    BlocProvider.of<CounterCubit>(context).decrement();
                    // context.bloc<CounterCubit>().decrement();
                  },
                  tooltip: 'Decrement',
                  child: Icon(Icons.remove),
                ),
                FloatingActionButton(
                  heroTag: Text('${widget.title} 2nd'),
                  onPressed: () {
                    // BlocProvider.of<CounterCubit>(context).increment();
                    BlocProvider.of<CounterCubit>(context).increment();
                  },
                  tooltip: 'Increment',
                  child: Icon(Icons.add),
                ),
              ],
            ),

            SizedBox(height: 24),
            goToStoreButton(context),
            SizedBox(height: 24),
            goToProfileButton(context),
            SizedBox(height: 24),
            goToCartButton(context),
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
        Navigator.of(context).pushNamed('/storemenu');
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
      child: Text('Go to Cart', style: TextStyle(color: Colors.black)),
      onPressed: () {
        Navigator.of(context).pushNamed('/shoppingcart');
      },
    );
  }
}
