import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirePage extends StatelessWidget {
  const FirePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      //stream: FirebaseFirestore.instance.collection('students').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>?;

              // Use ?. or ?? to safely access the data
              //var name = data?['name'] ?? 'No Name';
              var email = data?['email'] ?? 'No Email';

              return ListTile(
                //title: Text(name),
                subtitle: Text(email),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
