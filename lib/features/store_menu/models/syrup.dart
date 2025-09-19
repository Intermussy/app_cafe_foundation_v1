class Syrup {
  final String name;
  final int price;
  Syrup({required this.name, required this.price});

  List<Syrup> getMockSyrup() {
    final listMockSyrup = [
      Syrup(name: "Caramel", price: 6000),
      Syrup(name: "Golder Boba", price: 6000),
      Syrup(name: "Oreo", price: 6000),
    ];
    return listMockSyrup;
  }
}
