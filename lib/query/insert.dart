import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Insert extends StatefulWidget {
  @override
  _InsertState createState() => _InsertState();
}

class _InsertState extends State<Insert> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  void _addUserDataToFirestore(String name, int age) async {
    await _firestore.collection('user').add({'name': name, 'age': age});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: "Age"),
              keyboardType:
                  TextInputType.numberWithOptions(decimal: true), // เพิ่ม keyboardType เป็น number และกำหนดให้รองรับ decimal
            ),
            ElevatedButton(
              onPressed: () {
                _addUserDataToFirestore(
                    nameController.text, int.parse(ageController.text)); // แปลง String เป็น double ด้วย double.parse()
              },
              child: Text('Add'),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('user').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final documents = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final name = documents[index]['name'];
                      final age = documents[index]['age'];
                      return ListTile(
                        title: Text(name),
                        subtitle: Text(age.toString()),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}