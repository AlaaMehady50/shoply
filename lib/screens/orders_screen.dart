import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> orders = [
      {
        'id': 'ORD001',
        'productName': 'Cherry Red Bag',
        'price': 29.99,
        'quantity': 1,
        'date': '2025-07-20',
        'image': 'assets/images/cherry red bag.jpg',
      },
      {
        'id': 'ORD002',
        'productName': 'earrings',
        'price': 24.99,
        'quantity': 2,
        'date': '2025-07-21',
        'image': 'assets/images/earrings.jpg',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: orders.isEmpty
            ? Center(child: Text('No orders found'))
            : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    margin: EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          order['image'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return CircularProgressIndicator();
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error, size: 50);
                          },
                        ),
                      ),
                      title: Text('Order #${order['id']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Product: ${order['productName']}'),
                          Text('Quantity: ${order['quantity']}'),
                          Text('Total: \$${order['price'] * order['quantity']}'),
                          Text('Date: ${order['date']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}