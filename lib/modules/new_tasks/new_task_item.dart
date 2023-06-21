import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewTaskItem extends StatefulWidget {
  final taskModel;
  NewTaskItem({required this.taskModel});

  @override
  _NewTaskItemState createState() => _NewTaskItemState();
}

class _NewTaskItemState extends State<NewTaskItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text('${widget.taskModel['time']}',),
          ),
          SizedBox(width: 15,),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget.taskModel['title']}', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                Text('${widget.taskModel['date']}', style: TextStyle(color: Colors.grey[600]),),
              ],
            ),
          ),
          IconButton(
              onPressed: () {

              },
              icon: Icon(Icons.check_box, color: Colors.green,)),
          // SizedBox(width: 10,),
          IconButton(
              onPressed: () {

              },
              icon: Icon(Icons.archive_outlined, color: Colors.black54,)),

        ],
      ),
    );
  }
}
