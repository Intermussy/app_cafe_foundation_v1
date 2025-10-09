class DrinkCatalogModel {
  final int id;
  final String name;
  final int price;
  final String image;
  final bool iceAvailable;
  final bool hotAvailable;
  final bool regularSizeAvailable;
  final bool largeSizeAvailable;
  final String type;

  DrinkCatalogModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.iceAvailable,
    required this.hotAvailable,
    required this.regularSizeAvailable,
    required this.largeSizeAvailable,
    required this.type,
  });

  static List<DrinkCatalogModel> getMockList() {
    return [
      DrinkCatalogModel(
        id: 1,
        name: 'Cappucino',
        price: 20000,
        image: 'assets/images/placeholder.png',
        iceAvailable: true,
        hotAvailable: true,
        regularSizeAvailable: true,
        largeSizeAvailable: true,
        type: 'Coffee',
      ),
      DrinkCatalogModel(
        id: 2,
        name: 'Pistachio',
        price: 32000,
        image: 'assets/images/placeholder.png',
        iceAvailable: true,
        hotAvailable: true,
        regularSizeAvailable: true,
        largeSizeAvailable: false,
        type: 'Coffee',
      ),
      DrinkCatalogModel(
        id: 3,
        name: 'Vanilla Frappe',
        price: 24000,
        image: 'assets/images/placeholder.png',
        iceAvailable: true,
        hotAvailable: false,
        regularSizeAvailable: true,
        largeSizeAvailable: false,
        type: 'Non-coffee',
      ),
    ];
  }

  DrinkCatalogModel copyWith({
    int? id,
    String? name,
    int? price,
    String? image,
    bool? iceAvailable,
    bool? hotAvailable,
    bool? regularSizeAvailable,
    bool? largeSizeAvailable,
    String? type,
  }) {
    return DrinkCatalogModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      iceAvailable: iceAvailable ?? this.iceAvailable,
      hotAvailable: hotAvailable ?? this.hotAvailable,
      regularSizeAvailable: regularSizeAvailable ?? this.regularSizeAvailable,
      largeSizeAvailable: largeSizeAvailable ?? this.largeSizeAvailable,
      type: type ?? this.type,
    );
  }
}
