import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

class CreateUser extends StatefulWidget {
  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  // const CreteUser({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DateLocale _dateLocale = EnglishDateLocale();
    TextEditingController nameController = TextEditingController();
    final dateController = TextEditingController();

    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.black)),
              hintText: 'Full Name',
            ),
            controller: nameController,
          ),
          // Todo : KIV InputDatePicker()
          // InputDatePickerFormField(
          //   initialDate: DateTime(2000),
          //   firstDate: DateTime(1990),
          //   lastDate: DateTime(2010),
          // ),
          DateTimeField(
            controller: dateController,
            format: DateFormat("yyyy-MM-dd"),
            onShowPicker: (context, selection) {
              return showDatePicker(
                context: context,
                firstDate: DateTime(1990),
                initialDate: selection ?? DateTime(2000),
                lastDate: DateTime(2010),
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              final newUser = User(
                name: nameController.text,
                birthday: DateTime.parse(dateController.text),
              );
              addUser(newUser);
              // final nameVar=nameController.text;
              // createUser(nameF: nameVar);
            },
            child: Text('Add User'),
          )
        ],
      ),
    );
  }

  Future addUser(User user) async {
    final docUser = FirebaseFirestore.instance.collection('betaUsers').doc();
    user.id = docUser.id;
    final json = user.toJson();
    await docUser.set(json);
  }

  Future createUser({required String nameF}) async {
    // Reference to document
    final docUser = FirebaseFirestore.instance.collection('betaUsers').doc();
    final user =
        User(id: docUser.id, name: nameF, birthday: DateTime(1996, 4, 21));
    final json = user.toJson();

    // Create document and write data to Firebase
    await docUser.set(json);
  }
}

class User {
  String? id;
  final String name;
  final DateTime birthday;

  User({
    this.id,
    required this.name,
    required this.birthday,
  });

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'birthday': birthday};
}
