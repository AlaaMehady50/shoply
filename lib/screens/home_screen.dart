import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'product.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final prefs = snapshot.data!;
          final fullName = prefs.getString('full_name') ?? 'User';
          final profileImagePath = prefs.getString('profile_image');
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(fullName),
                accountEmail: Text(''),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  backgroundImage: profileImagePath != null && File(profileImagePath).existsSync()
                      ? FileImage(File(profileImagePath))
                      : null,
                  child: profileImagePath == null || !File(profileImagePath).existsSync()
                      ? Icon(Icons.person, size: 50)
                      : null,
                ),
                decoration: BoxDecoration(color: Colors.deepPurple),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              ListTile(
                leading: Icon(Icons.shopping_bag),
                title: Text('Orders'),
                onTap: () {
                  Navigator.pushNamed(context, '/orders');
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
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
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: Text("Products"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          )
        ],
      ),
      body: ListView(
        children: [
          SizedBox(height: 16),
          _buildImageSlider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              "New Arrivals",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          _buildProductGrid(),
        ],
      ),
    );
  }
}
