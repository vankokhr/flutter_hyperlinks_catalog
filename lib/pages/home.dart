import 'package:catalogdip/models/hyperlink.dart';
import 'package:catalogdip/pages/add_hyperlink.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:catalogdip/services/auth_service.dart';
import 'helpers/hyperlinks_card.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Object> catalogHyperlinks = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUsersHyperlinks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Rocket Manager'),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddHyperlink(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              iconSize: 30,
              color: Colors.white,
            )
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: ListView.builder(
        itemCount: catalogHyperlinks.length,
        itemBuilder: (context, int index) {
          return HyperlinksCard(catalogHyperlinks[index] as UserHyperlinks);
        },
      ),
    );
  }

  Future getUsersHyperlinks() async {
    final uid = AuthService().currentUser?.uid;
    var data = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('hyperlinks')
        .get();

    setState(
      () {
        catalogHyperlinks = List.from(
          data.docs.map(
            (doc) => UserHyperlinks.fromSnapshot(doc),
          ),
        );
      },
    );
  }
}
