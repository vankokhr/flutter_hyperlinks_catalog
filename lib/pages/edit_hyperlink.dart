import 'package:catalogdip/models/hyperlink.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'home.dart';

class EditHyperlink extends StatefulWidget {
  const EditHyperlink({required this.hyperlink, Key? key}) : super(key: key);

  final hyperlink;

  @override
  State<EditHyperlink> createState() => _EditHyperlinkState();
}

class _EditHyperlinkState extends State<EditHyperlink> {
  final formKey = GlobalKey<FormState>();

  String nameHyperlink = '';
  String valueHyperlink = '';
  String descHyperlink = '';

  @override
  Widget build(BuildContext context) {
    final hyperlink = widget.hyperlink;

    String idHyperlink = hyperlink.idHyperlink.toString();

    final hyperlinkNameField = TextFormField(
      autofocus: false,
      initialValue: hyperlink.nameHyperlink,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter ';
        }
        return null;
      },
      onSaved: (value) {
        nameHyperlink = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.drive_file_rename_outline),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Insert new name of hyperlink",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final hyperlinkField = TextFormField(
      autofocus: false,
      initialValue: hyperlink.hyperlink,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter hyperlink");
        }
        return null;
      },
      onSaved: (value) {
        valueHyperlink = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.add_link),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Insert new hyperlink",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final hyperlinkDescField = TextFormField(
      autofocus: false,
      initialValue: hyperlink.descHyperlink,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        descHyperlink = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.description),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Insert short description",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final editHyperlinkButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.deepPurpleAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
          }
          final editHyperlink = UserHyperlinks(
            descHyperlink: descHyperlink,
            hyperlink: valueHyperlink,
            nameHyperlink: nameHyperlink,
            idHyperlink: idHyperlink,
          );
          editUserHyperlink(editHyperlink);
        },
        child: const Text(
          'Edit info',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rocket Manager'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Edit information",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.deepPurpleAccent, fontSize: 30),
                    ),
                    const SizedBox(height: 30),
                    hyperlinkNameField,
                    const SizedBox(height: 20),
                    hyperlinkField,
                    const SizedBox(height: 20),
                    hyperlinkDescField,
                    const SizedBox(height: 30),
                    editHyperlinkButton,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future editUserHyperlink(UserHyperlinks editHyperlink) async {
    FirebaseFirestore hyperlinkInUser = FirebaseFirestore.instance;

    final uid = AuthService().currentUser?.uid;

    final data = hyperlinkInUser
        .collection('users')
        .doc(uid)
        .collection('hyperlinks')
        .doc(editHyperlink.idHyperlink);
    data.update(editHyperlink.toJson()).then(
        (value) => print("Document successfully updated!"),
        onError: (e) => print("Error updating document $e"));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Home(),
      ),
    );
  }
}
