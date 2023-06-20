import 'package:flutter/material.dart';
import 'new_task_item.dart';

class NewTasks extends StatefulWidget {
  List<Map> newTasksList ;
  NewTasks({required this.newTasksList});

  @override
  _NewTasksState createState() => _NewTasksState();
}

class _NewTasksState extends State<NewTasks> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => NewTaskItem(taskModel: widget.newTasksList[index]),
        separatorBuilder: (context, index) => Container(
              height: 1,
              color: Colors.grey,
            ),
        itemCount: widget.newTasksList.length);
  }
}
