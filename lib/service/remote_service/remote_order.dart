
// remote_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_grocery/model/order.dart'; // Sesuaikan dengan path model order Anda
import 'package:my_grocery/model/cart_item.dart'; // Sesuaikan dengan path model cart item Anda
import 'package:my_grocery/const.dart'; // Sesuaikan dengan path konstanta base URL Anda

class RemoteService {
  static final RemoteService _singleton = RemoteService._internal();

  factory RemoteService() {
    return _singleton;
  }

  RemoteService._internal();

  Future<http.Response> createOrder({
    required Order order,
    required String token,
  }) async {
    return await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(order.toJson()),
    );
  }

  Future<http.Response> updateOrder({
    required Order order,
    required String token,
  }) async {
    return await http.put(
      Uri.parse('$baseUrl/orders/${order.id}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(order.toJson()),
    );
  }

  Future<List<Order>> fetchOrders({
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<void> addToCart({
    required CartItem cartItem,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cartItems'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(cartItem.toJson()),
      );
      if (response.statusCode == 200) {
        print('Added to cart successfully');
      } else {
        throw Exception('Failed to add to cart');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeFromCart({
    required String cartItemId,
    required String token,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/cartItems/$cartItemId'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      if (response.statusCode == 200) {
        print('Removed from cart successfully');
      } else {
        throw Exception('Failed to remove from cart');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<CartItem>> fetchCart({
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/cartItems'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CartItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cart items');
    }
  }
}
