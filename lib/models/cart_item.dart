class CartItem {
  final String idMenu;
  final String name;
  final int harga;
  int quantity;

  CartItem({
    required this.idMenu,
    required this.name,
    required this.harga,
    this.quantity = 1,
  });
}
