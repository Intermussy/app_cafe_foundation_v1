abstract class AddonItem {
  final int id;
  final String name;
  final int price;
  AddonItem({required this.id, required this.name, required this.price});

  Map<String, dynamic> toMap();
}
