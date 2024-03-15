import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? productList = prefs.getStringList('products');
    if (productList != null) {
      setState(() {
        products = productList.map((json) => Product.fromJson(jsonDecode(json))).toList();
      });
    }
  }

  Future<void> _saveProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> productList = products.map((product) => jsonEncode(product.toJson())).toList();
    prefs.setStringList('products', productList);
  }

  void _addProduct(Product product) {
    setState(() {
      if (!products.contains(product)) {
        products.add(product);
        _saveProducts();
      }
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
      _saveProducts();
    });
  }

  void _searchProduct(String query) {
    setState(() {
      if (query.isEmpty) {
        // Reset products list if search query is empty
        _loadProducts();
      } else {
        // Filter products based on search query
        products = products.where((product) => product.name.toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // Clear user session and navigate to login page
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: searchController,
                  onChanged: _searchProduct,
                  decoration: InputDecoration(
                    labelText: 'Search Products',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        _searchProduct(searchController.text);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  'HiFi Service',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'Products and Services',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: products.isEmpty
                ? Center(child: Text('No Products Found'))
                : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 30.0,
                crossAxisSpacing: 20.0,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 2.5),
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  // Display the image asset from the product object
                                  image: AssetImage(products[index].imageAsset),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Text(
                              products[index].name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text('\$${products[index].price.toString()}'),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteProduct(index);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductPage(onAddProduct: _addProduct)),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Product {
  String name;
  double price;
  String imageAsset;

  Product({
    required this.name,
    required this.price,
    required this.imageAsset,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'imageAsset': imageAsset,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: json['price'],
      imageAsset: json['imageAsset'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product && other.name == name && other.price == price && other.imageAsset == imageAsset;
  }

  @override
  int get hashCode => name.hashCode ^ price.hashCode ^ imageAsset.hashCode;
}

class AddProductPage extends StatefulWidget {
  final Function(Product) onAddProduct;

  AddProductPage({required this.onAddProduct});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  String? _selectedImageAsset;
  List<String> _imageAssets = [
    'assets/images/JBL earbud.png',
    'assets/images/earphone white.png',
    'assets/images/Red boat ZE23RI.png',
    'assets/images/small bluetooth.png',
    'assets/images/boat earbud.png',
    'assets/images/apple ear bud.png',
    'assets/images/JBL black booster.png',
    'assets/images/black earphone.png',
    'assets/images/boat x3121.png',
    'assets/images/earbud X231.png',
  ];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Product Name',
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: priceController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product price';
                  }
                  double? price = double.tryParse(value);
                  if (price == null || price <= 0) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedImageAsset,
                onChanged: (value) {
                  setState(() {
                    _selectedImageAsset = value;
                  });
                },
                items: _imageAssets.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Select Image',
                ),
              ),
              SizedBox(height: 20),
              _selectedImageAsset != null
                  ? Image.asset(
                _selectedImageAsset!,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              )
                  : SizedBox(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && _selectedImageAsset != null) {
                    String name = nameController.text;
                    double price = double.parse(priceController.text);

                    widget.onAddProduct(Product(name: name, price: price, imageAsset: _selectedImageAsset!));
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
