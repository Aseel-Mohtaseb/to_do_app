import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/shard/cubit/cubit.dart';

class TaskItem extends StatelessWidget {
  final taskModel;
  TaskItem({required this.taskModel});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(taskModel['id'].toString()),
      onDismissed: (direction){
        AppCubit.get(context).deleteTaskStatus(id: taskModel['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text('${taskModel['time']}',),
            ),
            SizedBox(width: 15,),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${taskModel['title']}', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                  Text('${taskModel['date']}', style: TextStyle(color: Colors.grey[600]),),
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context).updateTaskStatus(status: 'done', id: taskModel['id']);
                },
                icon: Icon(Icons.check_box, color: Colors.green,)),
            // SizedBox(width: 10,),
            IconButton(
                onPressed: () {
                  AppCubit.get(context).updateTaskStatus(status: 'archived', id: taskModel['id']);

                },
                icon: Icon(Icons.archive_outlined, color: Colors.black54,)),

          ],
        ),
      ),
    );
  }
}



