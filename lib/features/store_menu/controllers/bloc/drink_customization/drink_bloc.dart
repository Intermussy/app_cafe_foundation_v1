import 'dart:async';
import 'package:app_foundation/features/store_menu/models/drink_detail_model.dart';
import 'package:app_foundation/features/store_menu/models/syrup.dart';
import 'package:app_foundation/features/store_menu/models/topping.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'drink_event.dart';
part 'drink_state.dart';

class DrinkBloc extends Bloc<DrinkEvent, DrinkState> {
  DrinkBloc({required DrinkDetailModel initialModel})
    : super(DrinkLoaded.initial(initialModel)) {
    on<DrinkEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<DrinkSubmit>(onDrinkSubmit);
    on<DrinkUpdateTempLevel>(onUpdateTemp);
    on<DrinkUpdateIceLevel>(onUpdateIce);
    on<DrinkUpdateSugarLevel>(onUpdateSugar);
    on<DrinkUpdateTopping>(
      onUpdateTopping,
      transformer: (events, mapper) => droppable<DrinkUpdateTopping>().call(
        events.debounceTime(const Duration(milliseconds: 250)),
        mapper,
      ),
    );
    on<DrinkUpdateSyrup>(
      onUpdateSyrup,
      transformer: (events, mapper) => droppable<DrinkUpdateSyrup>().call(
        events.debounceTime(const Duration(milliseconds: 250)),
        mapper,
      ),
    );
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
