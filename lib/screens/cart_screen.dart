import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [
    {
      'name': 'Product 1',
      'price': 29.99,
      'quantity': 1,
      'image': 'https://via.placeholder.com/100',
    },
    {
      'name': 'Product 2',
      'price': 30.99,
      'quantity': 3,
      'image': 'https://via.placeholder.com/100',
    },
    {
      'name': 'Product 4',
      'price': 32.99,
      'quantity': 1,
      'image': 'https://via.placeholder.com/100',
    },
  ];

  void increaseQuantity(int index) {
    setState(() {
      cartItems[index]['quantity']++;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (cartItems[index]['quantity'] > 1) {
        cartItems[index]['quantity']--;
      }
    });
  }

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  int get totalItems =>
    cartItems.fold(0, (sum, item) => sum + (item['quantity'] as int));

double get totalAmount => cartItems.fold(
  0.0,
  (sum, item) =>
      sum + ((item['price'] as double) * (item['quantity'] as int)),
);

  void placeOrder() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Order Confirmation'),
        content: Text('You are placing an order for $totalItems item(s) '
            'with a total of \$${totalAmount.toStringAsFixed(2)}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget buildCartItem(int index) {
    final item = cartItems[index];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(item['image'], height: 60, width: 60),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['name'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('\$${item['price'].toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.green)),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () => decreaseQuantity(index),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text(item['quantity'].toString(),
                    style: const TextStyle(fontSize: 16)),
                IconButton(
                  onPressed: () => increaseQuantity(index),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            IconButton(
              onPressed: () => removeItem(index),
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping Cart"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cartItems.length,
              itemBuilder: (_, index) => buildCartItem(index),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black12)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Total Items: $totalItems',
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Place Order',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
