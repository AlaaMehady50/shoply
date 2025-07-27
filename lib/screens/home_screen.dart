import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'product.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _onSearchPressed(BuildContext context) {
    showSearch(
      context: context,
      delegate: CustomSearchDelegate(),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final prefs = snapshot.data!;
          final fullName = prefs.getString('full_name') ?? 'User';
          final profileImagePath = prefs.getString('profile_image');
          final profileImageExists = profileImagePath != null && File(profileImagePath).existsSync();

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text(fullName),
                      accountEmail: const Text(''),
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        backgroundImage: profileImageExists ? FileImage(File(profileImagePath)) : null,
                        child: !profileImageExists ? const Icon(Icons.person, size: 50) : null,
                      ),
                      decoration: const BoxDecoration(color: Colors.deepPurple),
                    ),
                    ListTile(
                      leading: const Icon(Icons.home),
                      title: const Text('Home'),
                      onTap: () {
                        Navigator.pushNamed(context, '/home');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.shopping_cart),
                      title: const Text('Cart'),
                      onTap: () {
                        Navigator.pushNamed(context, '/cart');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Profile'),
                      onTap: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.help_outline),
                      title: const Text('Help & Support'),
                      onTap: () {
                        // Add navigation or functionality for Help & Support
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.shopping_bag),
                      title: const Text('Orders'),
                      onTap: () {
                        Navigator.pushNamed(context, '/orders');
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isLoggedIn', false);
                  Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImageSlider() {
    final List<String> images = [
      'assets/images/headphones.jpg',
      'assets/images/labubu.jpg',
      'assets/images/cherry red bag.jpg',
      'assets/images/classy watch.jpg',
      'assets/images/rolex watch for men.jpg',
    ];

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                images[index],
                width: 300,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    final products = [
      {
        'name': 'Headphones',
        'image': 'assets/images/headphones.jpg',
        'price': '\$19.99'
      },
      {
        'name': 'Women\'s Heel',
        'image': 'assets/images/women\'s heel.jpg',
        'price': '\$39.99'
      },
      {
        'name': 'Rolex Watch',
        'image': 'assets/images/rolex watch for men.jpg',
        'price': '\$99.99'
      },
      {
        'name': 'Hat',
        'image': 'assets/images/hat.jpg',
        'price': '\$14.99'
      },
      {
        'name': 'Earrings',
        'image': 'assets/images/earrings.jpg',
        'price': '\$24.99'
      },
      {
        'name': 'Cherry Red Bag',
        'image': 'assets/images/cherry red bag.jpg',
        'price': '\$34.99'
      },
      {
        'name': 'Classy Watch',
        'image': 'assets/images/classy watch.jpg',
        'price': '\$89.99'
      },
      {
        'name': 'Labubu Toy',
        'image': 'assets/images/labubu.jpg',
        'price': '\$29.99'
      },
      {
        'name': 'New Balance 530',
        'image': 'assets/images/new balance530.jpg',
        'price': '\$59.99'
      },
      {
        'name': 'Polo Shirt',
        'image': 'assets/images/polo shirt.jpg',
        'price': '\$27.99'
      },
      {
        'name': 'Socks',
        'image': 'assets/images/socks.jpg',
        'price': '\$9.99'
      },
      {
        'name': 'Sunglasses',
        'image': 'assets/images/sunglasses.jpg',
        'price': '\$19.99'
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics:const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Productpage(
                  productName: product['name']!,
                  productImage: product['image']!,
                  productPrice: double.tryParse(product['price']!.replaceAll('\$', '')) ?? 0.0,
                  productDescription: 'This is a stylish ${product['name']} with high-quality build.',
                ),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    product['image']!,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name']!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        product['price']!,
                        style: TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: Scaffold(
        drawer: _buildDrawer(context),
        appBar: AppBar(
          title: const Text("Products"),
          backgroundColor: Colors.deepPurple,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _onSearchPressed(context),
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
            ),
          ],
        ),
        body: ListView(
          children: [
            const SizedBox(height: 16),
            _buildImageSlider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                "New Arrivals",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            _buildProductGrid(),
          ],
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final List<Map<String, String>> products = [
    {
      'name': 'Headphones',
      'image': 'assets/images/headphones.jpg',
      'price': '\$19.99'
    },
    {
      'name': 'Women\'s Heel',
      'image': 'assets/images/women\'s heel.jpg',
      'price': '\$39.99'
    },
    {
      'name': 'Rolex Watch',
      'image': 'assets/images/rolex watch for men.jpg',
      'price': '\$99.99'
    },
    {
      'name': 'Hat',
      'image': 'assets/images/hat.jpg',
      'price': '\$14.99'
    },
    {
      'name': 'Earrings',
      'image': 'assets/images/earrings.jpg',
      'price': '\$24.99'
    },
    {
      'name': 'Cherry Red Bag',
      'image': 'assets/images/cherry red bag.jpg',
      'price': '\$34.99'
    },
    {
      'name': 'Classy Watch',
      'image': 'assets/images/classy watch.jpg',
      'price': '\$89.99'
    },
    {
      'name': 'Labubu Toy',
      'image': 'assets/images/labubu.jpg',
      'price': '\$29.99'
    },
    {
      'name': 'New Balance 530',
      'image': 'assets/images/new balance530.jpg',
      'price': '\$59.99'
    },
    {
      'name': 'Polo Shirt',
      'image': 'assets/images/polo shirt.jpg',
      'price': '\$27.99'
    },
    {
      'name': 'Socks',
      'image': 'assets/images/socks.jpg',
      'price': '\$9.99'
    },
    {
      'name': 'Sunglasses',
      'image': 'assets/images/sunglasses.jpg',
      'price': '\$19.99'
    },
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredProducts = products
        .where((product) => product['name']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return ListTile(
          leading: Image.asset(product['image']!, width: 50, height: 50, fit: BoxFit.cover),
          title: Text(product['name']!),
          subtitle: Text(product['price']!),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Productpage(
                  productName: product['name']!,
                  productImage: product['image']!,
                  productPrice: double.tryParse(product['price']!.replaceAll('\$', '')) ?? 0.0,
                  productDescription: 'This is a stylish ${product['name']} with high-quality build.',
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredProducts = products
        .where((product) => product['name']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return ListTile(
          leading: Image.asset(product['image']!, width: 50, height: 50, fit: BoxFit.cover),
          title: Text(product['name']!),
          subtitle: Text(product['price']!),
          onTap: () {
            query = product['name']!;
            showResults(context);
          },
        );
      },
    );
  }
}
