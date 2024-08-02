import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:practical_task/clientDB.dart';
import 'package:practical_task/viewDetails.dart';
import 'package:random_string/random_string.dart';

class addClient extends StatefulWidget {
  const addClient({super.key});

  @override
  State<addClient> createState() => _addClientState();
}

class _addClientState extends State<addClient> {

  //controller
  final _clientName = TextEditingController();
  final _clientContact = TextEditingController();
  final _clientEmail = TextEditingController();

  String? selectedBusiness;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(
          children: [
            Text("Add", style: TextStyle(color: Colors.blue, fontSize: 26)),
            SizedBox(
              width: 5,
            ),
            Text(
              "Client",
              style: TextStyle(color: Colors.orange, fontSize: 26),
            )
          ],
        )),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(children: [
            TextFormField(
              controller: _clientName,
              style: TextStyle(color: Colors.blue),
              decoration: InputDecoration(
                  labelText: "Enter Client Name",
                  labelStyle: TextStyle(color: Colors.orange),
                  border: OutlineInputBorder()),
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _clientContact,
              style: TextStyle(color: Colors.orange),
              decoration: InputDecoration(
                labelText: "Enter Client Contact",
                labelStyle: TextStyle(color: Colors.blue),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 10,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _clientEmail,
              style: TextStyle(color: Colors.blue),
              decoration: InputDecoration(
                  labelText: "Enter Client Email",
                  labelStyle: TextStyle(color: Colors.orange),
                  border: OutlineInputBorder()),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('Business').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No data available');
                }

                List<DropdownMenuItem<String>> dropdownItems =
                    snapshot.data!.docs.map((doc) {
                  try {
                    return DropdownMenuItem<String>(
                      value: doc['Name'] as String? ?? '',
                      child: Text(doc['Name'] as String? ?? ''),
                    );
                  } catch (e) {
                    return DropdownMenuItem<String>(
                      value: '',
                      child: Text('Error: $e'),
                    );
                  }
                }).toList();

                return DropdownButton<String>(
                  isExpanded: true,
                  value: selectedBusiness,
                  hint: Text('Select a Business',
                      style: TextStyle(color: Colors.blue)),
                  iconEnabledColor: Colors.blue,
                  items: dropdownItems,
                  onChanged: (value) {
                    setState(() {
                      selectedBusiness = value;
                    });
                  },
                );
              },
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancle",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.orange))),
                SizedBox(
                  width: 15,
                ),
                MaterialButton(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25)),
                  onPressed: () async {
                    String Id = randomAlphaNumeric(10);
                    Map<String, dynamic> clientInfoMap = {
                      "Id": Id,
                      "cName": _clientName.text,
                      "cContact": _clientContact.text,
                      "cEmail": _clientEmail.text,
                      "bName": selectedBusiness.toString()
                    };
                    await clientDb().addClientDetails(clientInfoMap, Id);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => viewDetails()));
                  },
                  child: Text("Add",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue)),
                )
              ],
            ),
          ]),
        )));
  }
}
