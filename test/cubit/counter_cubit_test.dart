import 'package:app_foundation/cubit/counter_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';

void main() {
  group('CounterCubit', () {
    CounterCubit counterCubit = CounterCubit();
    setUp(() {});

    tearDown(() {
      counterCubit.close();
    });

    test(
      'the initial state for the CounterCubit is CounterState(counterValue:0)',
      () {
        expect(
          counterCubit.state,
          CounterState(counterValue: 0, wasIncremented: false),
        );
      },
    );

    blocTest<CounterCubit, CounterState>(
      'the cubit should emit a counterState(counterValue: -1, wasIncremented: false) when cubit.decrement is called',
      build: () => counterCubit,
      act: (cubit) => cubit.decrement(),
      expect: () => <CounterState>[
        CounterState(counterValue: -1, wasIncremented: false),
      ],
    );
  });
}
