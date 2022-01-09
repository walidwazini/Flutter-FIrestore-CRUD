import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(StartApp());
}

class StartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
            .copyWith(secondary: Colors.cyan),
      ),
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? studentName, studentID, studentStudyProgram;
  double? studentGPA;

  getStudentName(name) {
    this.studentName = name;
  }

  getStudentID(studentId) {
    this.studentID = studentId;
  }

  getProgramId(programName) {
    this.studentStudyProgram = programName;
  }

  getGpa(gpa) {
    this.studentGPA = double.parse(gpa);
  }

  createData() {
    DocumentReference docReference =
        FirebaseFirestore.instance.collection('myStudents').doc(studentID);

    Map<String, dynamic> student = {
      'studentName': studentName,
      'studentID': studentID,
      'studentStudyProgram': studentStudyProgram,
      'studentGPA': studentGPA
    };

    docReference
        .set(student)
        .whenComplete(() => print('${studentName} is created '));
  }

  readData() {

  }

  updateData() {}

  deleteData() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter College'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Name',
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0))),
                  onChanged: (String name) {
                    getStudentName(name);
                  },
                ),
              ),
              _buildTextField('Student ID', (id) {
                getStudentID(id);
              }),
              _buildTextField('Study Program', (programId) {
                getProgramId(programId);
              }),
              _buildTextField('GPA', (gpa) {
                getGpa(gpa);
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 80,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        createData();
                      },
                      child: Text('Create'),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  _buildButton('Read', () {
                    readData();
                  }, Colors.blue),
                  _buildButton('Update', () {
                    updateData();
                  }, Colors.indigo),
                  _buildButton('Delete', () {
                    deleteData();
                  }, Colors.red),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, ValueChanged onChangeHandler) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: labelText,
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0))),
        onChanged: onChangeHandler,
      ),
    );
  }

  Widget _buildButton(String title, VoidCallback onPressHandler, Color warna) {
    return Container(
      width: 80,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressHandler,
        child: Text(title),
        style: ElevatedButton.styleFrom(
            primary: warna,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
