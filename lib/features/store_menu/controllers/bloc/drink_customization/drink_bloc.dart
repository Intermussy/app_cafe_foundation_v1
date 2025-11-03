import 'dart:async';
import 'package:app_foundation/commons/widgets/event_transformer_helper.dart';
import 'package:app_foundation/features/store_menu/models/drink_cart_model.dart';
import 'package:app_foundation/features/store_menu/models/drink_detail_model.dart';
import 'package:app_foundation/features/store_menu/models/syrup.dart';
import 'package:app_foundation/features/store_menu/models/topping.dart';
import 'package:app_foundation/features/store_menu/repositories/addon_repository.dart';
import 'package:app_foundation/features/store_menu/repositories/cart_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'drink_event.dart';
part 'drink_state.dart';

class DrinkBloc extends Bloc<DrinkEvent, DrinkState> {
  final _cartRepo = CartRepository();
  final _addonRepo = AddonRepository();
  DrinkBloc({required DrinkDetailModel initialModel})
    : super(DrinkLoaded.initial(initialModel)) {
    //trigger initialization

    //event handlers
    on<DrinkInitialized>(_onInitiailized);
    on<DrinkSubmit>(onDrinkSubmit);
    on<DrinkUpdateTempLevel>(onUpdateTemp);
    on<DrinkUpdateIceLevel>(onUpdateIce);
    on<DrinkUpdateSugarLevel>(onUpdateSugar);
    on<DrinkUpdateTopping>(
      onUpdateTopping,
      transformer: debounceDroppable<DrinkUpdateTopping>(
        const Duration(milliseconds: 250),
      ),
    );
    on<DrinkUpdateSyrup>(
      onUpdateSyrup,
      transformer: debounceDroppable<DrinkUpdateSyrup>(
        const Duration(milliseconds: 250),
      ),
    );
    on<DrinkIncrementQuantity>(onIncrement);
    on<DrinkDecrementQuantity>(onDecrement);

    add(DrinkInitialized());
  }

  FutureOr<void> onUpdateTemp(
    DrinkUpdateTempLevel event,
    Emitter<DrinkState> emit,
  ) {
    final current = state;
    if (current is DrinkLoaded) {
      emit(current.copyWith(selectedTemp: event.temperature));
    }
  }

  FutureOr<void> onUpdateTopping(
    DrinkUpdateTopping event,
    Emitter<DrinkState> emit,
  ) async {
    final current = state;
    if (current is DrinkLoaded) {
      if (current.selectedToppings.length < 3) {
        emit(
          current.copyWith(
            selectedToppings: List.from(event.toppings),
            totalPrice: current.getTotalPrice(),
          ),
        );
      }
    }
  }

  FutureOr<void> onUpdateIce(
    DrinkUpdateIceLevel event,
    Emitter<DrinkState> emit,
  ) {
    final current = state;
    if (current is DrinkLoaded) {
      emit(current.copyWith(selectedIce: event.ice));
    }
  }

  FutureOr<void> onUpdateSugar(
    DrinkUpdateSugarLevel event,
    Emitter<DrinkState> emit,
  ) {
    final current = state;
    if (current is DrinkLoaded) {
      emit(current.copyWith(selectedSugar: event.sugar));
    }
  }

  FutureOr<void> onUpdateSyrup(
    DrinkUpdateSyrup event,
    Emitter<DrinkState> emit,
  ) async {
    final current = state;
    if (current is DrinkLoaded) {
      if (current.selectedSyrups.length < 3) {
        emit(
          current.copyWith(
            selectedSyrups: List.from(event.syrups),
            totalPrice: current.getTotalPrice(),
          ),
        );
      }
    }
  }

  FutureOr<void> onIncrement(
    DrinkIncrementQuantity event,
    Emitter<DrinkState> emit,
  ) {
    final current = state;
    if (current is DrinkLoaded) {
      final updated = current.model.copyWith(
        quantity: current.model.quantity + event.changes,
      );
      emit(current.copyWith(model: updated));
    }
  }

  FutureOr<void> onDrinkSubmit(
    DrinkSubmit event,
    Emitter<DrinkState> emit,
  ) async {
    final current = state as DrinkLoaded;

    final newDrink = DrinkCartModel.fromBloc(current);
    var result = false;
    try {
      result = await _cartRepo.overWrite(newDrink);
    } catch (e) {
      emit(DrinkError(error: '$e'));
    } finally {
      if (result) {
        emit(DrinkSuccess(newDrink: newDrink));
      } else {
        emit(DrinkError(error: "Submit Fail!"));
      }
    }
  }

  FutureOr<void> onDecrement(
    DrinkDecrementQuantity event,
    Emitter<DrinkState> emit,
  ) {
    final current = state;
    if (current is DrinkLoaded) {
      final updated = current.model.copyWith(
        quantity: current.model.quantity - event.changes,
      );
      emit(current.copyWith(model: updated));
    }
  }

  FutureOr<void> _onInitiailized(
    DrinkInitialized event,
    Emitter<DrinkState> emit,
  ) async {
    final current = state as DrinkLoaded;
    emit(current.copyWith(isAddonLoading: true));
    final (toppings, syrups) = await _addonRepo.readAll();
    emit(
      current.copyWith(
        availableToppings: toppings,
        availableSyrups: syrups,
        isAddonLoading: false,
      ),
    );
  }
}
