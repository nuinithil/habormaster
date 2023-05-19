import 'package:flutter/material.dart';

class ShoppingListItem {
  final String id;
  final String title;
  final String? shoppingList;

  ShoppingListItem({
    required this.id,
    required this.title,
    this.shoppingList,
  });
}

class ShoppingList with ChangeNotifier {
  final List<ShoppingListItem> _shoppingLists = [];

//-------SEARCH FUNCTIONS---------
  List<ShoppingListItem> get shoppingLists {
    return [..._shoppingLists];
  }

  ShoppingListItem getShoppingListById(id) {
    return _shoppingLists.firstWhere((list) => list.id == id);
  }

  //-------DATA MANIPULATION FUNCTIONS---------
  void addShoppingList(ShoppingListItem item) {
    _shoppingLists.add(item);
    notifyListeners();
  }

  void updateShoppingList(String shoppingListId, ShoppingListItem item) {
    final loopIndex =
        _shoppingLists.indexWhere((item) => item.id == shoppingListId);
    if (loopIndex >= 0) {
      _shoppingLists[loopIndex] = item;
      notifyListeners();
    }
  }
}
