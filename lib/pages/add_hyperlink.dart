import 'package:catalogdip/models/hyperlink.dart';
import 'package:catalogdip/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:catalogdip/pages/home.dart';

class AddHyperlink extends StatefulWidget {
  const AddHyperlink({Key? key}) : super(key: key);

  @override
  State<AddHyperlink> createState() => _AddHyperlinkState();
}

class _AddHyperlinkState extends State<AddHyperlink> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController hyperlinkNameController = TextEditingController();
  final TextEditingController hyperlinkController = TextEditingController();
  final TextEditingController hyperlinkDescController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final hyperlinkNameField = TextFormField(
      autofocus: false,
      controller: hyperlinkNameController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter name of hyperlink");
        }
        return null;
      },
      onSaved: (value) {
        hyperlinkNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.drive_file_rename_outline),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Insert name of hyperlink",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final hyperlinkField = TextFormField(
      autofocus: false,
      controller: hyperlinkController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter hyperlink");
        }
        return null;
      },
      onSaved: (value) {
        hyperlinkController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.add_link),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Insert hyperlink",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final hyperlinkDescField = TextFormField(
      autofocus: false,
      controller: hyperlinkDescController,
      keyboardType: TextInputType.emailAddress,
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

    final addHyperlinkButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.deepPurpleAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          final newHyperlink = UserHyperlinks(
            descHyperlink: hyperlinkDescController.text,
            hyperlink: hyperlinkController.text,
            nameHyperlink: hyperlinkNameController.text,
            idHyperlink: "id_${hyperlinkNameController.text}",
          );
          createHyperlink(newHyperlink);
        },
        child: const Text(
          'Add hyperlink',
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
                      "Add your hyperlink",
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
                    addHyperlinkButton,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future createHyperlink(UserHyperlinks newHyperlink) async {
    FirebaseFirestore hyperlinkInUser = FirebaseFirestore.instance;

    final uid = AuthService().currentUser?.uid;

    //add link with user nameHyperlink
    final data = hyperlinkInUser
        .collection('users')
        .doc(uid)
        .collection('hyperlinks')
        .doc(newHyperlink.idHyperlink);
    data.set(newHyperlink.toJson()).then(
        (value) =>
            Fluttertoast.showToast(msg: "You successfully add hyperlink"),
        onError: (e) =>
            Fluttertoast.showToast(msg: "Error adding hyperlink $e"));
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => const Home()));
  }
}
