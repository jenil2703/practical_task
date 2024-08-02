import 'package:flutter/material.dart';
import 'package:practical_task/addBusiness.dart';
import 'package:practical_task/addclient.dart';

import 'viewDetails.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> name = ["Add Bussiness", "Add Client", "View Client Details"];

  void _onTapGrid(BuildContext context, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          'Clicked on ${name[index]}',
          style: TextStyle(color: Colors.orange),
        ),
      ),
    );
    if (index == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => addBusiness()));
    }
    if (index == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => addClient()));
    }
    if (index == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => viewDetails()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(
          children: [
            Text("Practical",
                style: TextStyle(color: Colors.blue, fontSize: 26)),
            SizedBox(
              width: 5,
            ),
            Text(
              "Task",
              style: TextStyle(color: Colors.orange, fontSize: 26),
            )
          ],
        )),
        body: Center(
          child: ListView.builder(
              itemCount: name.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => _onTapGrid(context, index),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: Card(
                      color: Colors.white,
                      elevation: 3,
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      shadowColor: Colors.black,
                      child: ListTile(
                        leading: Text(name[index],
                            style: TextStyle(
                                fontSize: 20, color: Colors.indigoAccent)),
                      ),
                    ),
                  ),
                );
              }),
        )
    );
  }
}
