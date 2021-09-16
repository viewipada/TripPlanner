import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot> productList() {
    return _firestore.collection("products").get();
  }

  Stream<DocumentSnapshot> product(String documentId){
    return _firestore.collection("products").doc(documentId).snapshots();
  }

  // String getDocIDOrder(){
  //   return _firestore.collection("orders").document().documentID;
  // }

  // Future<void> saveProduct(String name, int number, double price, String imgFile, double latitude, double longitude) async{
  //   return _firestore.collection("products").document()
  //     .setData({'name':name,'number':number,'price':price,'imgFile':imgFile,'latitude':latitude,'longitude':longitude}, merge: true);
  // }

  // Future<void> updateProduct(String id, String name, int number, double price, String imgFile) async{
  //   return _firestore.collection("products").document(id)
  //     .updateData({'name':name,'number':number,'price':price,'imgFile':imgFile});
  // }

}