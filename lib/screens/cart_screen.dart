import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _placeOrder(BuildContext context) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();

    // Retrieve existing orders
    final orders = prefs.getStringList('orders') ?? [];
    debugPrint('Existing orders: $orders');

    // Sanitize existing orders to ensure all entries are valid JSON strings
    final sanitizedOrders = orders.map((order) {
      try {
        return jsonEncode(jsonDecode(order));
      } catch (e) {
        debugPrint('Invalid order format: $order');
        return null;
      }
    }).where((order) => order != null).cast<String>().toList();

    // Create a new order with all cart items grouped together
    final newOrder = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'items': cartProvider.cartItems.map((item) => {
        'productName': item['name'],
        'price': item['price'],
        'quantity': 1,
        'image': item['image'],
      }).toList(),
      'date': DateTime.now().toIso8601String(),
    };

    sanitizedOrders.add(jsonEncode(newOrder));
    await prefs.setStringList('orders', sanitizedOrders);
    debugPrint('Updated orders: $sanitizedOrders');

    // Clear cart using CartProvider's method
    cartProvider.clearCart();

    // Show confirmation message
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Order Placed'),
        content: const Text('Your order has been placed successfully!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        backgroundColor: Colors.deepPurple,
      ),
      body: cartProvider.cartItems.isEmpty
          ? const Center(
              child: Text("Your cart is empty!"),
            )
          : ListView.builder(
              itemCount: cartProvider.cartItems.length,
              itemBuilder: (context, index) {
                final item = cartProvider.cartItems[index];
                return ListTile(
                  leading: Image.asset(item['image'], width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(item['name']),
                  subtitle: Text('Price: \$${item['price'].toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () {
                      cartProvider.removeFromCart(item);
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: \$${cartProvider.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () => _placeOrder(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: const Text("Place Order"),
            ),
          ],
        ),
      ),
    );
  }
}
