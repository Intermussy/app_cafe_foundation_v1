import 'package:app_foundation/bindings/rupiah_formatter.dart';
import 'package:app_foundation/commons/widgets/custom_toast.dart';
import 'package:app_foundation/features/store_menu/controllers/bloc/cart/cart_bloc.dart';
import 'package:app_foundation/features/store_menu/models/drink_cart_model.dart';
import 'package:app_foundation/features/store_menu/views/cart/item_cart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartListPage extends StatefulWidget {
  const CartListPage({super.key});

  @override
  State<CartListPage> createState() => _CartListPageState();
}

class _CartListPageState extends State<CartListPage> {
  FToast fToast = FToast();

  final _cartBloc = CartBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!mounted) return;
    fToast.init(context);
    _cartBloc.add(RequestCartEvent());
  }

  @override
  void didUpdateWidget(covariant CartListPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _cartBloc.add(RequestCartEvent());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _cartBloc.close();
    fToast.removeQueuedCustomToasts();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cartBloc,
      child: Scaffold(
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 6,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Center(
                child: BlocSelector<CartBloc, CartState, String>(
                  selector: (state) {
                    return state is CartLoaded
                        ? 'Total : ${RupiahFormatter.withRupiah(state.getTotalPrice())}'
                        : 'calculating...';
                  },
                  builder: (context, totalPrice) {
                    return Text(totalPrice);
                  },
                ),
              ),
            ),

            Container(
              height: 75,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.red,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 6,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: BlocSelector<CartBloc, CartState, List<DrinkCartModel>>(
                selector: (state) {
                  return state is CartLoaded ? state.cart : [];
                },
                builder: (context, state) {
                  return InkWell(
                    enableFeedback: state.isEmpty,
                    onTap: () {
                      if (state.isNotEmpty) {
                        _cartBloc.add(SubmitCartEvent(drinks: state));
                      } else {
                        fToast.removeQueuedCustomToasts();
                        fToast.showToast(
                          child: CustomToast.errorToast(
                            message: 'cart is empty!',
                          ),
                        );
                      }
                    },
                    child: Center(
                      child: Text(
                        'CONFIRM ORDER',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        appBar: AppBar(title: Text('Cart List')),
        body: SafeArea(
          child: BlocConsumer<CartBloc, CartState>(
            listener: (context, state) {
              if (state is CartSubmitSuccessful) {
                Navigator.pushReplacementNamed(
                  context,
                  '/orderreceipt',
                  arguments: state.cart,
                );
              }
            },
            buildWhen: (previous, current) {
              return previous is CartLoading;
            },
            builder: (context, state) {
              switch (state) {
                case CartLoaded _:
                  if (state.cart.isEmpty) {
                    return Center(child: Text('there is nothing here...'));
                  } else {
                    return RefreshIndicator(
                      onRefresh: () async => _cartBloc.add(RequestCartEvent()),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: state.cart.length,
                        itemBuilder: (context, index) {
                          final drink = state.cart[index];
                          return CartItemSelector(
                            key: ValueKey(drink.id),
                            itemId: drink.id,
                          );
                        },
                      ),
                    );
                  }
                default:
                  return Skeletonizer(
                    enabled: state is CartLoading,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      physics: BouncingScrollPhysics(),
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return Bone.square(
                          borderRadius: BorderRadius.circular(25),
                        );
                      },
                    ),
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
