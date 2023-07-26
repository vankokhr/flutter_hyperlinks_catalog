import 'package:catalogdip/pages/edit_hyperlink.dart';
import 'package:catalogdip/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/link.dart';

import '../../models/hyperlink.dart';
import '../home.dart';

class HyperlinksCard extends StatelessWidget {
  final UserHyperlinks _hyperlinks;

  const HyperlinksCard(this._hyperlinks, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String deleteIdHyperlink = _hyperlinks.idHyperlink.toString();

    Widget deleteButton = TextButton(
      onPressed: () {
        final deleteLink = UserHyperlinks(
          idHyperlink: deleteIdHyperlink,
        );
        deleteHyperlink(deleteLink);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Home()));
      },
      child: const Text('Yes'),
    );

    Widget cancelButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('No'),
    );

    AlertDialog alert = AlertDialog(
      title: const Text("You really wand delete this hyperlink?"),
      content: const Text("After deleting hyperlink you cannot restore it"),
      actions: [
        deleteButton,
        cancelButton,
      ],
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "${_hyperlinks.nameHyperlink}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditHyperlink(
                                  hyperlink: _hyperlinks,
                                )));
                  },
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Link(
                    uri: Uri.parse(_hyperlinks.hyperlink.toString()),
                    builder: (context, followLink) => GestureDetector(
                      onTap: followLink,
                      child: Text(
                        _hyperlinks.hyperlink.toString(),
                        style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "${_hyperlinks.descHyperlink}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  },
                  icon: const Icon(Icons.delete_forever),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future deleteHyperlink(UserHyperlinks deleteLink) async {
    FirebaseFirestore delete = FirebaseFirestore.instance;

    final uid = AuthService().currentUser?.uid;

    await delete
        .collection('users')
        .doc(uid)
        .collection('hyperlinks')
        .doc(deleteLink.idHyperlink)
        .delete()
        .then((doc) => Fluttertoast.showToast(msg: 'Hyperlink deleted'),
            onError: (e) =>
                Fluttertoast.showToast(msg: "Error deleting hyperlink $e"));
  }
}
