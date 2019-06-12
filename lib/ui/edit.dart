import 'package:flutter/material.dart';
import 'package:playground/models/student.dart';
import 'package:playground/utils/database_helper.dart';

class Edit extends StatefulWidget {
  final Student student;

  Edit({Key key, this.student}): super(key: key);

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _contactNumberController =
  TextEditingController();

  final db = DatabaseHelper();

  @override
  void initState() {
    super.initState();

    _firstNameController.text = widget.student.firstName;
    _lastNameController.text = widget.student.lastName;
    _contactNumberController.text = widget.student.contactNumber;
  }

  void _updateStudentRecord(String firstName, lastName, contactNumber) async {
    Student student = Student.fromMap({
      'firstName': firstName,
      'lastName': lastName,
      'contactNumber': contactNumber,
      'id': widget.student.id
    });

    await db.updateRecord(student);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        centerTitle: false,
        title: Text('Update Student'),
        backgroundColor: Colors.purple,
      ),
      body: Stack(
        children: <Widget>[
          Form(
            child: ListView(
              children: <Widget>[
                TextFormField(
                  controller: _firstNameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20.0),
                    labelText: 'First Name',
                  ),
                ),
                TextFormField(
                  controller: _lastNameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20.0),
                    labelText: 'Last Name',
                  ),
                ),
                TextFormField(
                  controller: _contactNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20.0),
                    labelText: 'Contact Number',
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 5.0,
            right: 5.0,
            bottom: 80.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text(
                    'Update Info',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  color: Colors.purple,
                  onPressed: () {
                    _updateStudentRecord(
                      _firstNameController.text,
                      _lastNameController.text,
                      _contactNumberController.text
                    );
                    
                    Navigator.popAndPushNamed(context, '/home');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
