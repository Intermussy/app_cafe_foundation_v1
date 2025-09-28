class Syrup {
  final String name;
  final int price;
  Syrup({required this.name, required this.price});

  static List<Syrup> getMockList() {
    final listMockSyrup = [
      Syrup(name: "Whipped Cream", price: 3000),
      Syrup(name: "Vanilla Syrup", price: 3000),
      Syrup(name: "Oreo", price: 3000),
    ];
    return listMockSyrup;
  }
}
