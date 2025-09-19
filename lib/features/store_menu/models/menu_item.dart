class MenuItem {
  final String name;
  final int price;
  final bool iceAvailable;
  final bool hotAvailable;
  final bool regularSizeAvailable;
  final bool largeSizeAvailable;

  MenuItem({
    required this.name,
    required this.price,
    required this.iceAvailable,
    required this.hotAvailable,
    required this.regularSizeAvailable,
    required this.largeSizeAvailable,
  });

  MenuItem copyWith({
    String? name,
    int? price,
    bool? iceAvailable,
    bool? hotAvailable,
    bool? regularSizeAvailable,
    bool? largeSizeAvailable,
  }) {
    return MenuItem(
      name: name ?? this.name,
      price: price ?? this.price,
      iceAvailable: iceAvailable ?? this.iceAvailable,
      hotAvailable: hotAvailable ?? this.hotAvailable,
      regularSizeAvailable: regularSizeAvailable ?? this.regularSizeAvailable,
      largeSizeAvailable: largeSizeAvailable ?? this.largeSizeAvailable,
    );
  }
}
