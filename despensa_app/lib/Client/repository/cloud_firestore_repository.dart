import 'package:despensaapp/Client/model/client.dart';
import 'package:despensaapp/Client/repository/cloud_firestore_api.dart';

import 'package:despensaapp/Product/model/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:despensaapp/Client/repository/cloud_firestore_api.dart';

class CloudFirestoreRepository {
  final _cloudFirestoreAPI = CloudFirestoreAPI();

  void updateClientDataFirestore(Client client) =>
      _cloudFirestoreAPI.updateClientData(client);

  Future<void> updateProductData(Product product) => _cloudFirestoreAPI.updateProductData(product);

  List<Product> buildProducts(List<DocumentSnapshot> productsListSnapshot, Client user) => _cloudFirestoreAPI.buildProducts(productsListSnapshot, user);

  Future likeProduct(Product product, String uid) => _cloudFirestoreAPI.likeProduct(product,uid);
  Future addProduct(Product product, String uid, bool plus, bool newP) => _cloudFirestoreAPI.addProduct(product,uid,plus, newP);

  Future addFavorites(Product product, String uid) => _cloudFirestoreAPI.addFavorites(product,uid);
  Future addCart(Product product, String uid) => _cloudFirestoreAPI.addCart(product,uid);

  Future clearShoppingCart(String uid, List<Product> products) => _cloudFirestoreAPI.clearShoppingCart(uid, products);
}
