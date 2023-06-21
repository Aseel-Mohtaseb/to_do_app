import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/shard/cubit/cubit.dart';
import 'package:to_do_app/shard/cubit/states.dart';
import '../../shard/task_item.dart';

class NewTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).newTasksList;
        return ListView.separated(
            itemBuilder: (context, index) => TaskItem(taskModel: tasks[index]),
            separatorBuilder: (context, index) => Container(
              height: 1,
              color: Colors.grey,
            ),
            itemCount: tasks.length);
      },
    );
  }
}

