import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/loginpage.dart';
import 'package:getx/viewdetails.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String image;
  final String brand;
  final double rating;
  final List<String> images;
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    required this.brand,
    required this.rating,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown Title',
      description: json['description'] ?? 'No Description',
      price: (json['price'] != null) ? json['price'].toDouble() : 0.0,
      rating: (json['rating'] != null) ? json['rating'].toDouble() : 0.0,
      image: json['thumbnail'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      brand: json['brand'] ?? 'Unknown brand',
    );
  }
}

class dashboard extends StatefulWidget {
  const dashboard({super.key});

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  Future<List<Product>> fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://dummyjson.com/products'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['products'];
      return jsonData.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  Future<void> _signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
    setState(() {
      _user = null;
      Get.to(loginpage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            'Dashboard'.toUpperCase(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              tooltip: 'Sign Out',
              onPressed: _signOut,
            ),
          ],
        ),
        body: FutureBuilder<List<Product>>(
          future: futureProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No products found'));
            }

            final products = snapshot.data!;

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Material(
                  elevation: 50,
                  child: GestureDetector(
                    onTap: () {
                      Get.to(ProductDetailPage(product: product));
                    },
                    child: ListTile(
                      title: Text(
                        product.title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Brand: ${product.brand}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue)),
                          Text('Price: \$${product.price.toString()}'),
                        ],
                      ),
                      leading: Container(
                        width: 90,
                        height: 90,
                        child: product.image.isNotEmpty
                            ? Image.network(
                                product.image,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.image_not_supported),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                );
              },
            );
          },
        ),
        drawer: drawerData());
  }

  Widget drawerData() {
    var box = Hive.box('mybox');
    var email = box.get('email');
    var displayName = box.get('displayName');
    var photoURL = box.get('photoURL');
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(photoURL),
                ),
                SizedBox(height: 10),
                Text(
                  displayName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text(email),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          
        ],
      ),
    );
  }
}
