import 'package:cloud_firestore/cloud_firestore.dart';

class clientDb {
  Future addClientDetails(Map<String, dynamic> clientInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Client")
        .doc(id)
        .set(clientInfoMap);
  }

  Future<Stream<QuerySnapshot>> getClientdetails() async {
    return await FirebaseFirestore.instance.collection("Client").snapshots();
  }

  // Future delClientDetails(String id) async {
  //   return await FirebaseFirestore.instance.collection("Client").doc(id);
  // }
}
