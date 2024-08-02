import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:practical_task/businessDB.dart';
import 'package:random_string/random_string.dart';

class addBusiness extends StatefulWidget {
  const addBusiness({super.key});

  @override
  State<addBusiness> createState() => _addBusinessState();
}

class _addBusinessState extends State<addBusiness> {

  //controller
  final _businessName = TextEditingController();
  final _businessContact = TextEditingController();
  final _businessEmail = TextEditingController();
  final _businessAddress = TextEditingController();

  _clearText() {
    _businessName.clear();
    _businessContact.clear();
    _businessEmail.clear();
    _businessAddress.clear();
  }

  //get all details from collection
  final Stream<QuerySnapshot> studentRecords = FirebaseFirestore.instance.collection('Business').snapshots();

  //get data in listview from firestore
  Stream? BusinessStream;

  getonload() async{
    BusinessStream = await dbMethods().getBussinessdetails();
    setState(() {

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    getonload();
    super.initState();
  }

  //get data in listview
  Widget allBusinessdetails(){
    return StreamBuilder(stream: BusinessStream, builder: (context,AsyncSnapshot snapshot){
      if (snapshot.hasData) {
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context,index){
            DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
            return Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Card(
                color: Colors.white,
                elevation: 3,
                shadowColor: Colors.black,
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text("Business Name :" +documentSnapshot["Name"],style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                      [
                        Text("Business Contact :: " +documentSnapshot["Contact"],style: TextStyle(color: Colors.orange)),
                        Text("Business Email :: " +documentSnapshot["Email"],style: TextStyle(color: Colors.blue)),
                        Text("Business Address :: " +documentSnapshot["Address"],style: TextStyle(color: Colors.orange)),
                      ],
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
              children:
              [
                Text("Add",style: TextStyle(color: Colors.blue,fontSize: 26)),
                SizedBox(width: 5,),
                Text("Business",style: TextStyle(color: Colors.orange,fontSize: 26),)
              ],
            )),

        body: Center(
          child: allBusinessdetails(),
        ),

        //floating action button
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
          onPressed: () {
            SimpleDialog dialog = SimpleDialog(
              shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30)),
              elevation: 3,
              shadowColor: Colors.black,
              //backgroundColor: Colors.white,
              children: [
                SimpleDialogOption(
                    child: Row(
                      children:
                      [
                        Text("Add",style: TextStyle(color: Colors.blue,fontSize: 24)),
                        SizedBox(width: 5,),
                        Text("Business",style: TextStyle(color: Colors.orange,fontSize: 24)),
                      ],
                    )
                ),
                SizedBox(height: 5,),

                SimpleDialogOption(
                  child: TextFormField(
                    controller: _businessName,
                    style: TextStyle(color: Colors.orange),
                    decoration: InputDecoration(
                        labelText: "Enter Business Name",
                        labelStyle: TextStyle(color: Colors.blue),
                        border: OutlineInputBorder()
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                SizedBox(height: 5,),

                SimpleDialogOption(
                  child: TextFormField(
                    controller: _businessContact,
                    style: TextStyle(color: Colors.blue),
                    decoration: InputDecoration(
                      labelText: "Enter Business Contact",
                      labelStyle: TextStyle(color: Colors.orange),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                  ),
                ),
                SizedBox(height: 5,),

                SimpleDialogOption(
                  child: TextFormField(
                    controller: _businessEmail,
                    style: TextStyle(color: Colors.orange),
                    decoration: InputDecoration(
                        labelText: "Enter Business Email",
                        labelStyle: TextStyle(color: Colors.blue),
                        border: OutlineInputBorder()
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(height: 5,),

                SimpleDialogOption(
                  child: TextFormField(
                    controller: _businessAddress,
                    style: TextStyle(color: Colors.blue),
                    decoration: InputDecoration(
                        labelText: "Enter Business Address",
                        labelStyle: TextStyle(color: Colors.orange),
                        border: OutlineInputBorder()
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                SizedBox(height: 5,),

                SimpleDialogOption(
                    child: MaterialButton(
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25)),
                      onPressed: () {
                        setState(() async{
                          String id = randomAlphaNumeric(10);
                          Map<String,dynamic> businessInfoMap = {
                            "Id" : id,
                            "Name" : _businessName.text,
                            "Contact" : _businessContact.text,
                            "Email" : _businessEmail.text,
                            "Address" : _businessAddress.text,
                          };

                          await dbMethods().addBusinessDetails(businessInfoMap,id);
                          _clearText();
                          Navigator.of(context).pop();
                        });
                      },
                      child: Text("Add", style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18,color: Colors.blue),),
                    )
                ),
              ],
            );
            showDialog
              (
              context: context,
              builder: (BuildContext context) {
                return dialog;
              },
            );
          }, child: Icon(Icons.add),
        ),
      );
    }
}
