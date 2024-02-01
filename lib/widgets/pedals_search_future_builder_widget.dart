import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PedalsSearchFutureBuilderWidget extends StatelessWidget {
  final String text;
  const PedalsSearchFutureBuilderWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('pedals')
            .where('name', isGreaterThanOrEqualTo: text)
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return snapshot.data!.docs.isEmpty
              ? const SizedBox()
              : Text(
                  snapshot.data!.docs[0]['name'],
                );
        },
      ),
    );
  }
}
