import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_provider.dart';

class Repository {
  final _firestoreProvider = FirestoreProvider();

  Stream<DocumentSnapshot> product(String documentId) =>
    _firestoreProvider.product(documentId);
  
  Future<QuerySnapshot> productList() =>
    _firestoreProvider.productList();

  // String getDocIDOrder() =>
  //   _firestoreProvider.getDocIDOrder();
  
  // Future<void> saveProduct(String name, int number, double price, String imgFile, double latitude, double longitude) =>
  //   _firestoreProvider.saveProduct(name, number, price, imgFile, latitude, longitude);
  
  // Future<void> updateProduct(String id, String name, int number, double price, String imgFile) =>
  //   _firestoreProvider.updateProduct(id, name, number, price, imgFile);
  
}