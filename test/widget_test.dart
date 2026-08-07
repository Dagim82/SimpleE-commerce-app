import 'dart:convert';

import 'package:e_commerce_app/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final productJson = {
    'id': 1,
    'title': 'Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops',
    'price': 109.95,
    'description': 'Your perfect pack for everyday use and walks in the forest.',
    'category': "men's clothing",
    'image': 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_t.png',
    'rating': {'rate': 3.9, 'count': 120},
  };

  test('Product.fromJson parses API data', () {
    final product = Product.fromJson(productJson);

    expect(product.id, 1);
    expect(product.title, contains('Foldsack'));
    expect(product.price, 109.95);
    expect(product.category, "men's clothing");
    expect(product.rating.rate, 3.9);
    expect(product.rating.count, 120);
  });

  test('Product.toJson returns the original shape', () {
    final product = Product.fromJson(productJson);
    final json = product.toJson();

    expect(json['id'], 1);
    expect(json['price'], 109.95);
    expect((json['rating'] as Map<String, dynamic>)['rate'], 3.9);
  });

  test('CartItem round-trips through JSON', () {
    final product = Product.fromJson(productJson);
    final item = CartItem(product: product, quantity: 3);

    final restored = CartItem.fromJson(
      jsonDecode(jsonEncode(item.toJson())) as Map<String, dynamic>,
    );

    expect(restored.product.id, 1);
    expect(restored.quantity, 3);
    expect(restored.totalPrice, 3 * 109.95);
  });

  test('User.fromJson flattens name and address', () {
    final userJson = {
      'address': {
        'geolocation': {'lat': '-37.3159', 'long': '81.1496'},
        'city': 'kilcoole',
        'street': 'Lovers Ln',
        'number': 7267,
        'zipcode': '12926-3874',
      },
      'id': 2,
      'email': 'morrison@gmail.com',
      'username': 'mor_2314',
      'name': {'firstname': 'david', 'lastname': 'morrison'},
      'phone': '1-570-236-7033',
    };

    final user = User.fromJson(userJson);

    expect(user.username, 'mor_2314');
    expect(user.fullName, 'david morrison');
    expect(user.address.city, 'kilcoole');
    expect(user.address.number, 7267);
  });
}
