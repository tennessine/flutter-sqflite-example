import 'package:flutter/material.dart';
import 'package:playground/models/student.dart';
import 'package:playground/ui/edit.dart';
import 'package:playground/ui/entry.dart';
import 'package:playground/utils/database_helper.dart';

class Records extends StatefulWidget {
  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  final List<Student> _studentRecords = <Student>[];
  var db = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _readDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: ListTile(
          title: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purple,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => Entry()));
        },
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: false,
              itemCount: _studentRecords.length,
              itemBuilder: (_, int index) {
                return Card(
                  child: ListTile(
                    title: _studentRecords[index],
                    onLongPress: () => _editStudent(_studentRecords[index], index),
                    trailing: Listener(
                      key: Key(_studentRecords[index].firstName),
                      child: Icon(Icons.remove_circle, color: Colors.red,),
                      onPointerDown: (_) => _deleteStudent(_studentRecords[index].id, index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _readDatabase() async {
    List studentRecords = await db.getStudentRecords();
    studentRecords.forEach((studentItem) {
      Student student = Student.fromMap(studentItem);
      setState(() {
        _studentRecords.add(student);
      });
    });
  }

  void _deleteStudent(int id, int index) async {
    await db.deleteRecord(id);
    setState(() {
      _studentRecords.removeAt(index);
    });
  }

  void _editStudent(Student student, int index) async {
    student = _studentRecords[index];
    var route = MaterialPageRoute(
      builder: (BuildContext context) => Edit(student: student),
    );
    Navigator.of(context).push(route);
  }
}
