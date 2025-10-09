import 'dart:async';

import 'package:app_foundation/features/store_menu/models/drink_cart_model.dart';
import 'package:app_foundation/features/store_menu/models/drink_detail_model.dart';
import 'package:app_foundation/features/store_menu/models/syrup.dart';
import 'package:app_foundation/features/store_menu/models/topping.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'drink_event.dart';
part 'drink_state.dart';

class DrinkBloc extends Bloc<DrinkEvent, DrinkState> {
  DrinkBloc({DrinkDetailModel? initialModel})
    : super(
        initialModel != null
            ? DrinkLoaded.initial(initialModel)
            : DrinkInitial(),
      ) {
    on<DrinkEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<DrinkSubmit>(onDrinkSubmit);
    on<DrinkUpdateTempLevel>(onUpdateTemp);
    on<DrinkUpdateIceLevel>(onUpdateIce);
    on<DrinkUpdateSugarLevel>(onUpdateSugar);
    on<DrinkUpdateTopping>(onUpdateTopping);
    on<DrinkUpdateSyrup>(onUpdateSyrup);
    on<DrinkIncrementQuantity>(onIncrement);
    on<DrinkDecrementQuantity>(onDecrement);
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
  ) {
    final current = state;
    if (current is DrinkLoaded) {
      emit(
        current.copyWith(
          selectedToppings: event.toppings,
          totalPrice: current.getTotalPrice(),
        ),
      );
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
  ) {
    final current = state;
    if (current is DrinkLoaded) {
      emit(
        current.copyWith(
          selectedSyrups: event.syrups,
          totalPrice: current.getTotalPrice(),
        ),
      );
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

  FutureOr<void> onDrinkSubmit(DrinkSubmit event, Emitter<DrinkState> emit) {
    final current = state;
    if (current is DrinkLoaded) {}
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
}
