class DrinkMenuView {
  final String name;
  final int price;
  final bool iceAvailable;
  final bool hotAvailable;
  final bool regularSizeAvailable;
  final bool largeSizeAvailable;
  final String type;
  DrinkMenuView({
    required this.name,
    required this.price,
    required this.iceAvailable,
    required this.hotAvailable,
    required this.regularSizeAvailable,
    required this.largeSizeAvailable,
    required this.type,
  });

  DrinkMenuView copyWith({
    String? name,
    int? price,
    bool? iceAvailable,
    bool? hotAvailable,
    bool? regularSizeAvailable,
    bool? largeSizeAvailable,
    String? type,
  }) {
    return DrinkMenuView(
      name: name ?? this.name,
      price: price ?? this.price,
      iceAvailable: iceAvailable ?? this.iceAvailable,
      hotAvailable: hotAvailable ?? this.hotAvailable,
      regularSizeAvailable: regularSizeAvailable ?? this.regularSizeAvailable,
      largeSizeAvailable: largeSizeAvailable ?? this.largeSizeAvailable,
      type: type ?? this.type,
    );
  }

  static List<DrinkMenuView> getMockList() {
    return [
      DrinkMenuView(
        name: 'Cappucino',
        price: 20000,
        iceAvailable: true,
        hotAvailable: true,
        regularSizeAvailable: true,
        largeSizeAvailable: true,
        type: 'Coffee',
      ),
      DrinkMenuView(
        name: 'Pistachio',
        price: 32000,
        iceAvailable: true,
        hotAvailable: true,
        regularSizeAvailable: true,
        largeSizeAvailable: false,
        type: 'Coffee',
      ),
      DrinkMenuView(
        name: 'Vanilla Frappe',
        price: 24000,
        iceAvailable: true,
        hotAvailable: false,
        regularSizeAvailable: true,
        largeSizeAvailable: false,
        type: 'Non-coffee',
      ),
    ];
  }
}
