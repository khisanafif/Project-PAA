import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Checkout extends StatefulWidget {
  final List<List<dynamic>> cart;

  Checkout({required this.cart});

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  double subtotal = 0.0;
  final _formKey = GlobalKey<FormState>();
  Map<String, String> form = {
    'name': '',
    'email': '',
    'address': '',
    'phone': ''
  };

  @override
  void initState() {
    super.initState();
    calculateSubtotal();
  }

  void calculateSubtotal() {
    double total = 0.0;
    for (var item in widget.cart) {
      total += item[1];
    }
    setState(() {
      subtotal = total;
    });
  }

  void handleChange(String field, String value) {
    setState(() {
      form[field] = value;
    });
  }

  void submit() async {
    // Generate order ID
    String orderId = "OID${(1000000 * (new DateTime.now().millisecondsSinceEpoch)).toInt()}";

    // Example URL and API call
    String url = "https://efficient-life-0decbcd91b.strapiapp.com/admin/api/orders/pretransaction";

    // Example data to be sent to the server
    var data = {
      'orderid': orderId,
      'amount': subtotal,
      ...form,
      'cart': widget.cart
    };

    // Make the HTTP request
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        var content = jsonDecode(response.body);

        var config = {
          "root": "",
          "flow": "DEFAULT",
          "data": {
            "orderId": orderId,
            "token": content['body']['txnToken'], // Replace with actual token from response
            "tokenType": "TXN_TOKEN",
            "amount": subtotal
          },
          "handler": {
            "notifyMerchant": (String eventName, dynamic data) {
              print("notifyMerchant handler function called");
              print("eventName => $eventName");
              print("data => $data");
            }
          }
        };

        // Initialize and invoke Paytm CheckoutJS (Note: This is a placeholder)
        // Implement Paytm CheckoutJS logic here
        // You'll need to handle this using a WebView or another method in Flutter.
      } else {
        print('Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Checkout', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text('Cart', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(widget.cart.isNotEmpty ? 'Your cart details are as follows:' : 'Your cart is empty!'),
              SizedBox(height: 16),
              ...widget.cart.map((item) => ListTile(
                title: Text('Product ${item[0]}'),
                subtitle: Text('Price: ₹${item[1]}'),
              )),
              Divider(),
              Text('Subtotal: ₹$subtotal', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Name'),
                      onChanged: (value) => handleChange('name', value),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Email'),
                      onChanged: (value) => handleChange('email', value),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Phone'),
                      onChanged: (value) => handleChange('phone', value),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Address'),
                      maxLines: 4,
                      onChanged: (value) => handleChange('address', value),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: submit,
                      child: Text('Pay Now'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
