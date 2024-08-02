import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'clientDB.dart';

class viewDetails extends StatefulWidget {
  const viewDetails({super.key});

  @override
  State<viewDetails> createState() => _viewDetailsState();
}

class _viewDetailsState extends State<viewDetails> {
  String? selectedBusiness;

  //get data into listview from firestore
  Stream? ClientStream;

  getonload() async {
    ClientStream = await clientDb().getClientdetails();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getonload();
    super.initState();
  }

  //get data in listview
  Widget allClientdetails() {
    return StreamBuilder(
        stream: ClientStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                      child: Card(
                        elevation: 3,
                        shadowColor: Colors.black,
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            "Client Name :: " + documentSnapshot["cName"],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Client Contact :: " +
                                      documentSnapshot["cContact"],
                                  style: TextStyle(color: Colors.orange)),
                              Text(
                                  "Client Email :: " +
                                      documentSnapshot["cEmail"],
                                  style: TextStyle(color: Colors.blue)),
                              Text(
                                  "Business Name :: " +
                                      documentSnapshot["bName"],
                                  style: TextStyle(color: Colors.orange)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return Center(child: Text('No businesses found'));
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          Text("Client", style: TextStyle(color: Colors.blue, fontSize: 26)),
          SizedBox(
            width: 5,
          ),
          Text(
            "Details",
            style: TextStyle(color: Colors.orange, fontSize: 26),
          )
        ],
      )),
      body: Center(
          child: allClientdetails(),
      ));
  }
}
