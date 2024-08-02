import 'package:cloud_firestore/cloud_firestore.dart';

class dbMethods
{
  Future addBusinessDetails(
      Map<String, dynamic> businessInfoMap, String id) async{
    return await FirebaseFirestore.instance
        .collection("Business")
        .doc(id)
        .set(businessInfoMap);
  }

  Future<Stream<QuerySnapshot>> getBussinessdetails()async{
    return await FirebaseFirestore.instance.collection("Business").snapshots();
  }

}

