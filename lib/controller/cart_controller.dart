import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:my_grocery/model/cart_item.dart';
import 'package:my_grocery/service/remote_service/remote_order.dart'; 
import 'package:my_grocery/const.dart'; // Sesuaikan dengan path remote service Anda
import 'package:my_grocery/service/local_service/local_auth_service.dart'; // Sesuaikan dengan path LocalAuthService Anda

class CartController extends GetxController {
  static CartController instance = Get.find();
  final String apiUrl = "$baseUrl/api/cartItems"; // Sesuaikan dengan URL API Strapi Anda
  var cartItems = <CartItem>[].obs;
  var isLoading = false.obs;
  final LocalAuthService _localAuthService = LocalAuthService(); // Tambahkan ini

  Future<void> fetchCartItems() async {
    isLoading.value = true;

    try {
      String? token = await _localAuthService.getToken(); // Ambil token
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        cartItems.value = data.map((cartItemJson) => CartItem.fromJson(cartItemJson)).toList();
      } else {
        throw Exception('Failed to load cart items');
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToCart(CartItem cartItem) async {
    try {
      String? token = await _localAuthService.getToken(); // Ambil token
      final response = await RemoteService().addToCart(
        cartItem: cartItem,
        token: token!, // Gunakan token
      );
      if (response.statusCode == 200) {
        cartItems.add(cartItem);
      } else {
        throw Exception('Failed to add to cart');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeFromCart(String cartItemId) async {
    try {
      String? token = await _localAuthService.getToken(); // Ambil token
      final response = await RemoteService().removeFromCart(
        cartItemId: cartItemId,
        token: token!, // Gunakan token
      );
      if (response.statusCode == 200) {
        cartItems.removeWhere((item) => item.id == cartItemId);
      } else {
        throw Exception('Failed to remove from cart');
      }
    } catch (e) {
      print(e);
    }
  }
}
