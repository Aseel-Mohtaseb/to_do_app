import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/shard/cubit/cubit.dart';
import 'package:to_do_app/shard/cubit/states.dart';
import '../new_tasks/new_task_item.dart';

class DoneTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).doneTasksList;
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

