import 'package:flutter/material.dart';
import 'package:ukk_cafe/models/cart_item.dart';

class CartNotifier extends ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(CartItem item) {
    final existingItem = _cartItems.firstWhere(
      (cartItem) => cartItem.idMenu == item.idMenu,
      orElse: () => CartItem(
        idMenu: item.idMenu,
        name: item.name,
        harga: item.harga,
        quantity: 0,
      ),
    );

    if (existingItem.quantity > 0) {
      existingItem.quantity += item.quantity;
    } else {
      _cartItems.add(item);
    }

    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Tambahkan fungsi ini untuk mengupdate kuantitas
  void updateQuantity(int index, int newQuantity) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems[index].quantity = newQuantity;
      notifyListeners();
    }
  }
}
