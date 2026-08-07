import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models.dart';
import 'storage_service.dart';

class CartState {
  final List<CartItem> items;

  const CartState({this.items = const []});

  int get totalQuantity =>
      items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  bool get isEmpty => items.isEmpty;

  int quantityOf(int productId) {
    for (final item in items) {
      if (item.product.id == productId) {
        return item.quantity;
      }
    }
    return 0;
  }
}

class CartController extends Notifier<CartState> {
  final CartState _initialState;

  CartController({CartState? initialState})
      : _initialState = initialState ?? const CartState();

  @override
  CartState build() => _initialState;

  Future<void> _persist() async {
    await ref.read(storageServiceProvider).saveCart(state.items);
  }

  List<CartItem> _withQuantity(int productId, int newQuantity) {
    return state.items.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();
  }

  Future<void> add(Product product) async {
    final existing = state.quantityOf(product.id);
    if (existing == 0) {
      state = CartState(
        items: [...state.items, CartItem(product: product, quantity: 1)],
      );
    } else {
      state = CartState(items: _withQuantity(product.id, existing + 1));
    }
    await _persist();
  }

  Future<void> increment(int productId) async {
    final current = state.quantityOf(productId);
    if (current == 0) return;
    state = CartState(items: _withQuantity(productId, current + 1));
    await _persist();
  }

  Future<void> decrement(int productId) async {
    final current = state.quantityOf(productId);
    if (current == 0) return;
    if (current == 1) {
      state = CartState(
        items: state.items.where((i) => i.product.id != productId).toList(),
      );
    } else {
      state = CartState(items: _withQuantity(productId, current - 1));
    }
    await _persist();
  }

  Future<void> remove(int productId) async {
    state = CartState(
      items: state.items.where((i) => i.product.id != productId).toList(),
    );
    await _persist();
  }

  Future<void> clear() async {
    state = const CartState();
    await _persist();
  }
}

final cartProvider =
    NotifierProvider<CartController, CartState>(CartController.new);
