import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'order_details_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future<List<Map<String, dynamic>>> _fetchOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final orders = prefs.getStringList('orders') ?? [];
    debugPrint('Fetched orders: \$orders');
    
    // Filter out invalid orders and return only valid ones
    final validOrders = <Map<String, dynamic>>[];
    for (final order in orders) {
      try {
        final decodedOrder = jsonDecode(order) as Map<String, dynamic>;
        final items = decodedOrder['items'] as List<dynamic>?;
        if (items != null && items.isNotEmpty) {
          validOrders.add(decodedOrder);
        }
      } catch (e) {
        debugPrint('Skipping invalid order: $order');
      }
    }
    
    return validOrders;
  }

  Future<void> _deleteOrder(String orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final orders = prefs.getStringList('orders') ?? [];

    // Filter out the order with the given ID
    final updatedOrders = orders.where((order) {
      final decodedOrder = jsonDecode(order) as Map<String, dynamic>;
      return decodedOrder['id'] != orderId;
    }).toList();

    await prefs.setStringList('orders', updatedOrders);
    debugPrint('Updated orders after deletion: $updatedOrders');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          final orders = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final items = order['items'] as List<dynamic>;

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      items[0]['image'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error, size: 50);
                      },
                    ),
                  ),
                  title: Text('Order #${order['id']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Product: ${items[0]['productName']}'),
                      Text('Quantity: ${items[0]['quantity']}'),
                      Text('Total: \$${items[0]['price'] * items[0]['quantity']}'),
                      Text('Date: ${order['date']}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await _deleteOrder(order['id']);
                      setState(() {});
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsScreen(order: order),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}