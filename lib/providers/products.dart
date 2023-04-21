import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    /*Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 299.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
    Product(
      id: 'p5',
      title: 'A Shoe',
      description: 'Keep Calm Hide the new shoe under the Bed!.',
      price: 1299.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/2/23/Whole-cut_shoe.jpg',
    ),
    Product(
      id: 'p6',
      title: 'FacePowder',
      description:
          'Treat your makeup like jewelry for the face. Play with colors, shapes, structure – it can transform you!.',
      price: 1299.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/3/38/Hudnut-duBarry_Face_Powder.jpg',
    ),
    Product(
      id: 'p7',
      title: 'Macbook Air',
      description: 'Featuring the most stlish and full with features - macbook',
      price: 127999.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/5/50/Macbook_Air_M1_Silver_PNG.png',
    ),
    Product(
      id: 'p8',
      title: 'Couch',
      description:
          'Enoy your daily gossips and meals sitting in this lightweight couch',
      price: 27999.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/d/d9/Kubus_sofa.jpg',
    ),
    Product(
      id: 'p9',
      title: 'Galaxy Z Fold',
      description: 'Capture the beautiful pictures of the world',
      price: 87999.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/f/f3/Galaxy_Z_Fold.jpg',
    ),
    Product(
      id: 'p10',
      title: 'Refrigerator',
      description:
          'keep your daily meals and stuffs healthy and safe with some extra enabled features',
      price: 84000.99,
      imageUrl:
          'https://images.samsung.com/is/image/samsung/p6pim/in/rf57a5232sl-tl/gallery/in-water-dispenser-convertible-freezer-rf57a5232sl-tl-436341150?650_519_PNG',
    ),
    Product(
      id: 'p11',
      title: 'Curtain',
      description:
          'Decorate your rooms and dining halls with some beautiful gadgets',
      price: 99.99,
      imageUrl: 'https://m.media-amazon.com/images/I/5183EN0KeVL.jpg',
    ),
    Product(
      id: 'p12',
      title: 'Bat',
      description: 'Hit your enemies and balls out of the boundary',
      price: 1750.99,
      imageUrl:
          'https://m.media-amazon.com/images/I/41AnNu6VL2L._SX300_SY300_QL70_FMwebp_.jpg',
    ),*/
  ];

  //var _showFavoritesOnly = false;

  List<Product> get items {
    //if (_showFavoritesOnly) {
    //  return _items.where((prodItem) => prodItem.isFavourite).toList();
    //}
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://shopnow-daf27-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String,dynamic>;
      final List<Products> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
                id: prodId,
                title: prodData['title'],
                description: prodData['description'],
                price: prodData['price'],
                isFavorite: prodData['isFavorite'],
                imageUrl: prodData['imageUrl'],) as Products);
      });
      _items = loadedProducts.cast<Product>();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shopnow-daf27-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      //_items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
