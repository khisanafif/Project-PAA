 import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:my_grocery/model/order.dart';
import 'package:my_grocery/service/remote_service/remote_order.dart'; // Sesuaikan dengan path remote service Anda

class OrderController extends GetxController {
  static OrderController instance = Get.find();
  final String apiUrl = "YOUR_STRAPI_URL/api/orders"; // Sesuaikan dengan URL API Strapi Anda
  var orders = <Order>[].obs;
  var isLoading = false.obs;

  Future<void> fetchOrders() async {
    isLoading.value = true;

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        orders.value = data.map((orderJson) => Order.fromJson(orderJson)).toList();
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createOrder(Order order) async {
    try {
      final response = await RemoteService().createOrder(
        order: order,
        token: 'YOUR_TOKEN_HERE', // Sesuaikan dengan token autentikasi dari LocalAuthService atau tempat penyimpanan token Anda
      );
      if (response.statusCode == 200) {
        orders.add(Order.fromJson(jsonDecode(response.body)));
      } else {
        throw Exception('Failed to create order');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateOrder(Order order) async {
    try {
      final response = await RemoteService().updateOrder(
        order: order,
        token: 'YOUR_TOKEN_HERE', // Sesuaikan dengan token autentikasi dari LocalAuthService atau tempat penyimpanan token Anda
      );
      if (response.statusCode == 200) {
        int index = orders.indexWhere((o) => o.id == order.id);
        if (index != -1) {
          orders[index] = order;
        }
      } else {
        throw Exception('Failed to update order');
      }
    } catch (e) {
      print(e);
    }
  }
}