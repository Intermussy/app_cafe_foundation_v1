class Topping {
  final String name;
  final int price;
  Topping({required this.name, required this.price});

  static Topping getMockData() {
    return Topping(name: "Caramel", price: 6000);
  }

  static List<Topping> getMockList() {
    final listMockTopping = [
      Topping(name: "Caramel", price: 6000),
      Topping(name: "Golden Boba", price: 6000),
      Topping(name: "Oreo", price: 6000),
    ];
    return listMockTopping;
  }
}
