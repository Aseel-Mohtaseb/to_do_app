import 'package:flutter/cupertino.dart';

class NewTasks extends StatefulWidget {
  const NewTasks({Key? key}) : super(key: key);

  @override
  _NewTasksState createState() => _NewTasksState();
}

class _NewTasksState extends State<NewTasks> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text('new tasks'));
  }
}
