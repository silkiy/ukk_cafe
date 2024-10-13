import 'package:flutter/material.dart';
import '../models/menu.dart';

class MenuNotifier extends ChangeNotifier {
  List<Menu> _menuItems = []; // List to hold menu items
  List<String> _selectedItems =
      []; // List to hold selected menu items (for orders)

  List<Menu> get menuItems => _menuItems; // Getter for menu items

  List<String> get selectedItems => _selectedItems; // Getter for selected items

  void setMenuItems(List<Menu> items) {
    _menuItems = items; // Set menu items
    notifyListeners(); // Notify listeners of change
  }

  void toggleSelection(String itemId) {
    if (_selectedItems.contains(itemId)) {
      _selectedItems.remove(itemId); // Deselect the item
    } else {
      _selectedItems.add(itemId); // Select the item
    }
    notifyListeners(); // Notify listeners of change
  }
}
