part of 'menu_bloc.dart';

@immutable
sealed class MenuEvent {}

class MenuSeachEvent extends MenuEvent {
  final String query;
  MenuSeachEvent({required this.query});
}

class LoadMenuEvent extends MenuEvent {}

class MenuFilterTypeEvent extends MenuEvent {
  final String type;
  MenuFilterTypeEvent({required this.type});
}
